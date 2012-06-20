Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2FTJmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:42:17 -0400
Received: from plane.gmane.org ([80.91.229.3]:60554 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2FTJmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:42:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: regression with dynpm [was: [git pull] drm-fixes]
Date: Wed, 20 Jun 2012 11:41:54 +0200
Message-ID: <4FE19AE2.5040605@web.de>
References: <alpine.DEB.2.00.1206170838050.26175@skynet.skynet.ie> <4FE087D1.2000708@web.de> <CAPM=9txSPOtLE=2POGp46MvEZ0AK0_BXLPc83k7us5wrWawSkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p5b373e1f.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
In-Reply-To: <CAPM=9txSPOtLE=2POGp46MvEZ0AK0_BXLPc83k7us5wrWawSkA@mail.gmail.com>
Cc: dri-devel@lists.freedesktop.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote, on 06/19/12 16:11:
> On Tue, Jun 19, 2012 at 3:08 PM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
>> Dave Airlie wrote, on 06/17/12 09:42:
>>>
>>> Hi Linus,
>>>
>>> radeon is most of the work, one regression, one BUG fix in the new prime
>>> code, some fixes to init code to make streamout not lock up the hardware,
>>> and just some code to enable users to test HDMI audio on later hw (its off by
>>> default).
>>>
>>> Intel adds edp edid caching for some strange Dell Vostros that black
>>> screen on startup if keep reading their EDID, and a fix for a DP
>>> regression.
>>>
>>> Otherwise fix for via/sis and one to stop udl binding to multiple
>>> non-video usb.
>>>
>>> Dave.
>>>
>>> The following changes since commit 9b15b817f3d62409290fd56fe3cbb076a931bb0a:
>>>
>>>   swap: fix shmem swapping when more than 8 areas (2012-06-15 21:48:14 -0700)
>>>
>>> are available in the git repository at:
>>>
>>>   git://people.freedesktop.org/~airlied/linux drm-fixes
>>>
>>> for you to fetch changes up to c4af5c4597a7a5d64e058703e1328f315a59794e:
>>>
>>>   Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2012-06-16 14:45:17 +0100)
>>>
>>> ----------------------------------------------------------------
>>>
>>> Alex Deucher (3):
>>>       drm/radeon: fix regression in dynpm due to multi-ring rework
>>>       drm/radeon: add some additional 6xx/7xx/EG register init
>>>       drm/radeon: add support for STRMOUT_BASE_UPDATE on 7xx
>>>
>>
>> Hello Dave,
>>
>> on my HP Pavilion dv7 there is still with 3.5-rc3 a severe problem with the
>> dynpm option. After booting, the machine freezes (hard-lock) when trying to
>> switch to dynamic power mangement on the integrated GPU via
>>
> 
> These fixes went in after -rc3, so make sure you have them.
> 
> Dave.

Hi Dave,

indeed, with this fix from Alex (drm/radeon: fix regression in dynpm due to
multi-ring rework) on top of 3.5-rc3, dynpm is working again on the HP Pavilion dv7.
Thanks for your caring.

-- 
Best regards,
Jörg-Volker.

