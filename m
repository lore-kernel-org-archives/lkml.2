Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0FYN2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:28:15 -0400
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59634 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab0FYN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:28:13 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2010 09:28:13 EDT
Message-ID: <4C24AEE4.4090700@bu3sch.de>
Date: Fri, 25 Jun 2010 15:28:04 +0200
From: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net,
       zajec5@gmail.com
Subject: Re: [PATCH 0/3] b43: logging cleanups
References: <cover.1276988387.git.joe@perches.com>	 <20100624185339.GC2368@tuxdriver.com> <1277408432.1654.80.camel@Joe-Laptop.home> (sfid-20100624_214041_280758_2585CA6E)
In-Reply-To: <1277408432.1654.80.camel@Joe-Laptop.home> (sfid-20100624_214041_280758_2585CA6E)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 09:40 PM, Joe Perches wrote:
> On Thu, 2010-06-24 at 14:53 -0400, John W. Linville wrote:
>> On Sat, Jun 19, 2010 at 04:30:08PM -0700, Joe Perches wrote:
>>> Just some small cleanups
>>> Joe Perches (3):
>>>    drivers/net/wireless/b43: Use local ratelimit_state
>>>    drivers/net/wireless/b43: Logging cleanups
>>>    drivers/net/wireless/b43: Rename b43_debug to b43_debugging
>> Any of the b43 guys want to express an opinion on these?

The cleanups, well, exchange one name for the other. I don't have a
strong opinion on one or the other. So in the end I don't see why
that stuff should be renamed. However, in the end I really do not care.

I'm not sure why we need an additional ratelimit here. Is it a policy
that every kernel driver should have local ratelimiting? If not, why
do you think b43 needs its own ratelimiting? Note that b43 does not
output a single line to dmesg in normal operation, after init has
finished (and ratelimit is disabled in init).

> Stefano, are you active here?
> Your last ack for b43 was Feb 2008.
> There have been 400+ commits to b43 without your ack.
>
> Should your name be moved from MAINTAINERS to CREDITS?
>
> $ ./scripts/get_maintainer.pl --rolestats -f drivers/net/wireless/b43/
> Stefano Brivio<stefano.brivio@polimi.it>  (maintainer:B43 WIRELESS DRIVER)
> "John W. Linville"<linville@tuxdriver.com>  (maintainer:NETWORKING [WIREL...,commit_signer:204/240=85%)
> "Rafał Miłecki"<zajec5@gmail.com>  (commit_signer:83/240=35%)
> "Gábor Stefanik"<netrolller.3d@gmail.com>  (commit_signer:44/240=18%)
> Michael Buesch<mb@bu3sch.de>  (commit_signer:39/240=16%)
> Larry Finger<Larry.Finger@lwfinger.net>  (commit_signer:13/240=5%)
> linux-wireless@vger.kernel.org (open list:B43 WIRELESS DRIVER)
> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)

I think these statistics are almost worthless for b43.

-- 
Greetings Michael.
