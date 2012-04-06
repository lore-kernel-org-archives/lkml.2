Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab2DFFLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:11:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62691 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2DFFLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:11:54 -0400
MIME-Version: 1.0
In-Reply-To: <4F7DE3A4.1040705@candelatech.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
Date: Fri, 6 Apr 2012 10:41:53 +0530
Message-ID: <CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Michael Leun <lkml20120218@newton.leun.net>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, Apr 5, 2012 at 11:55 PM, Ben Greear <greearb@candelatech.com> wrote:
> I see the regression on my WPEA-127N systems as well.
>
> With the patch applied to 3.3.1, I see never ending stream of
> auth timeouts (this log is watching 'iw event' output)
>
> power-management is OFF on my system, and using nohwcrypt,
> in case that matters.
>
> This is with 10 virtual stations.
>
> 2012-04-05 11:16:14.155  1.1:  sta5 (phy #0): scan finished: 2412 2417 2422
> 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260
> 5280 5300 5320 5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5745
> 5765 5785 5805 5825, ""
> 2012-04-05 11:16:15.266  1.1:  sta0 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta1 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta2 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta3 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta4 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta6 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta7 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta8 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta9 (phy #0): auth: timed out
> 2012-04-05 11:16:15.266  1.1:  sta5 (phy #0): auth: timed out
> 2012-04-05 11:16:19.400  1.1:  sta0 (phy #0): scan started
> 2012-04-05 11:16:23.302  1.1:  sta0 (phy #0): scan finished: 2412 2417 2422
> 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260
> 5280 5300 5320 5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5745
> 5765 5785 5805 5825, ""
> 2012-04-05 11:16:24.406  1.1:  sta1 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta2 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta3 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta4 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta5 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta6 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta7 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta8 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta9 (phy #0): auth: timed out
> 2012-04-05 11:16:24.406  1.1:  sta0 (phy #0): auth: timed out
>
> I reverted the patch and then it associates immediately.
>
> Occasionally, I would see things associate and run OK with the patch
> in place, but it always took a lot of re-tries to associate
> even when it did work.

i think its best for me try to download the 3.3.1 stable kernel and
see if this issue happens,
i am going to start it now, Ben does this happens with  latest
wireless testing tree?
its quite weird 3.4-rc1 works as some user reported and while 3.3.1 does not.
i will try to come with some suggestion patches

>
> I can easily test patches or try things if anyone has any ideas.
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>



-- 
thanks,
shafi
