Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab0IXWDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:03:42 -0400
Received: from skyboo.net ([82.160.187.4]:43278 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753705Ab0IXWDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:03:41 -0400
Message-ID: <4C9D3C4D.60904@skyboo.net>
Date: Sat, 25 Sep 2010 02:03:25 +0200
From: Mariusz Bialonczyk <manio@skyboo.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
References: <4C940D5C.4090408@skyboo.net> <4C953A66.3070003@skyboo.net>
In-Reply-To: <4C953A66.3070003@skyboo.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:470:1f0b:1af:f000::2
X-SA-Exim-Mail-From: manio@skyboo.net
Subject: Re: PROBLEM: GPT partition table + RAID: kernel could not load init
 while root filesystem is mounted
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on skyboo.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2010 12:17 AM, Mariusz Bialonczyk wrote:
> after some investigation i am almost sure that the problem is with
> kernel_execve()

... and i was damn wrong!
I put a lot of debug printf's inside init and i must admit that INIT is
launched correctly! So i think it's not a kernel problem here because it
successfully starting init, sorry for bothering you, guys :(
I also bisected the place where init stops and it totally freezes when
calling: close(2). I was also testing upstart with same hung results
(upstart it also closing stderr).
Sorry for little off-topic question: Maybe you know why sysvinit and
upstart cannot close stderr when booting md from GPT partition table?
grub2 problem?

regards
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
