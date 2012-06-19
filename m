Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2FSOLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:11:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36430 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2FSOLt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:11:49 -0400
MIME-Version: 1.0
In-Reply-To: <4FE087D1.2000708@web.de>
References: <alpine.DEB.2.00.1206170838050.26175@skynet.skynet.ie>
	<4FE087D1.2000708@web.de>
Date: Tue, 19 Jun 2012 15:11:48 +0100
Message-ID: <CAPM=9txSPOtLE=2POGp46MvEZ0AK0_BXLPc83k7us5wrWawSkA@mail.gmail.com>
Subject: Re: regression with dynpm [was: [git pull] drm-fixes]
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?J=F6rg=2DVolker_Peetz?= <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 3:08 PM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
> Dave Airlie wrote, on 06/17/12 09:42:
>>
>> Hi Linus,
>>
>> radeon is most of the work, one regression, one BUG fix in the new prime
>> code, some fixes to init code to make streamout not lock up the hardware,
>> and just some code to enable users to test HDMI audio on later hw (its off by
>> default).
>>
>> Intel adds edp edid caching for some strange Dell Vostros that black
>> screen on startup if keep reading their EDID, and a fix for a DP
>> regression.
>>
>> Otherwise fix for via/sis and one to stop udl binding to multiple
>> non-video usb.
>>
>> Dave.
>>
>> The following changes since commit 9b15b817f3d62409290fd56fe3cbb076a931bb0a:
>>
>>   swap: fix shmem swapping when more than 8 areas (2012-06-15 21:48:14 -0700)
>>
>> are available in the git repository at:
>>
>>   git://people.freedesktop.org/~airlied/linux drm-fixes
>>
>> for you to fetch changes up to c4af5c4597a7a5d64e058703e1328f315a59794e:
>>
>>   Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2012-06-16 14:45:17 +0100)
>>
>> ----------------------------------------------------------------
>>
>> Alex Deucher (3):
>>       drm/radeon: fix regression in dynpm due to multi-ring rework
>>       drm/radeon: add some additional 6xx/7xx/EG register init
>>       drm/radeon: add support for STRMOUT_BASE_UPDATE on 7xx
>>
>
> Hello Dave,
>
> on my HP Pavilion dv7 there is still with 3.5-rc3 a severe problem with the
> dynpm option. After booting, the machine freezes (hard-lock) when trying to
> switch to dynamic power mangement on the integrated GPU via
>

These fixes went in after -rc3, so make sure you have them.

Dave.
