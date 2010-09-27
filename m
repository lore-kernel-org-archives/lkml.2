Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0I0KFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:05:34 -0400
Received: from skyboo.net ([82.160.187.4]:40400 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750872Ab0I0KFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:05:32 -0400
Message-ID: <4CA0887F.3050505@skyboo.net>
Date: Mon, 27 Sep 2010 14:05:19 +0200
From: Mariusz Bialonczyk <manio@skyboo.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
References: <4C940D5C.4090408@skyboo.net> <4C953A66.3070003@skyboo.net> <4C9D3C4D.60904@skyboo.net>
In-Reply-To: <4C9D3C4D.60904@skyboo.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:470:1f0b:1af:f000::2
X-SA-Exim-Mail-From: manio@skyboo.net
Subject: [SOLVED] Re: PROBLEM: GPT partition table + RAID: kernel could not
 load init while root filesystem is mounted
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on skyboo.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2010 02:03 AM, Mariusz Bialonczyk wrote:
> Sorry for little off-topic question: Maybe you know why sysvinit and
> upstart cannot close stderr when booting md from GPT partition table?
> grub2 problem?

everything is now clear
i was doing rsync with -x when copying data - so /dev nodes was not
copied because /dev was mounted as tmpfs - so as a result i have
empty /dev directory on /dev/md0 (boot partition)

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
