Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2GaRXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:23:38 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36908 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752135Ab2GaRXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:23:35 -0400
Message-ID: <50181451.5040202@xenotime.net>
Date: Tue, 31 Jul 2012 10:22:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for July 31 (media/radio-tea5777)
References: <20120731152614.de6ebe9e0d4b8fc6645b793a@canb.auug.org.au>
In-Reply-To: <20120731152614.de6ebe9e0d4b8fc6645b793a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 10:26 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120730:
> 


on i386:

drivers/built-in.o: In function `radio_tea5777_set_freq':
radio-tea5777.c:(.text+0x4d8704): undefined reference to `__udivdi3'



-- 
~Randy
