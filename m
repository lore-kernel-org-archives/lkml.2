Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab1CEOXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 09:23:21 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50270 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab1CEOXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 09:23:20 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.38-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Date: Sat, 5 Mar 2011 15:23:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7-tp42-00142-g212e349; KDE/4.5.3; i686; ; )
Cc: DRI <dri-devel@lists.freedesktop.org>
References: <201103051510.35057.Martin@lichtvoll.de> (sfid-20110305_151616_695932_4AD33AC9)
In-Reply-To: <201103051510.35057.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103051523.17315.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Saturday 05 March 2011 schrieb Martin Steigerwald:
> I will add a regression entry in bugzilla after I got the URL of that
> mail.
> 
> 
> Hi!
> 
> No, I do not actively search for lockup bugs, but they seem to search
> me ;).
> 
> 
> martin@shambhala:~> cat /proc/version
> Linux version 2.6.38-rc7-tp42-00142-g212e349 (martin@shambhala) (gcc
> version 4.4.5 (Debian 4.4.5-11) ) #4 PREEMPT Sat Mar 5 12:03:41 CET
> 2011
> 
> locks up hard when using desktop cube of kwin from KDE 4.5.1.
> 
> It happens within a few seconds to about 30 seconds after activating
> the effect with Ctrl-F11. Otherwise the machine seems to work fine so
> far - if that continues I do not have much of a problem with the bug
[...]

Reported as

Bug 30472 - 2.6.38-post-rc7 with radeon kms: reproducably locks up hard 
when using desktop cube of kwin

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
