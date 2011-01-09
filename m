Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab1AIRHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 12:07:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49952 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1AIRHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 12:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=GHIskh9T/wXSCpKOaIMFY6EFKAUwTjsQ1TBoFdDQZOo3phwFE7JpPoVLjO4uOO5ZHh
         l9ZTupE3+VKSzK9MgGnVvX8yxTk7VbD4WlCdUTNm1jrOpcsK1cEdE/z1Y0U47nQmVIum
         YeD0R04NDuNeg8y0aNCjmlfgkTaf5R3hup7KU=
MIME-Version: 1.0
In-Reply-To: <AANLkTinCSu68cC_jzO8MZs4Q=u+EABiZxkRv3gbyfqMk@mail.gmail.com>
References: <AANLkTinCSu68cC_jzO8MZs4Q=u+EABiZxkRv3gbyfqMk@mail.gmail.com>
Date: Sun, 9 Jan 2011 22:37:48 +0530
Message-ID: <AANLkTin4yh3mQ7pbGPvYFNgNnRDVrmJUD4yUJT1tusC7@mail.gmail.com>
Subject: Re: Bug in linux-2.6.37-rc8+: Weird X display upon hibernating
From: Siddu <siddu.sjce@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems like its not getting much attention here .... atleast can anyone
tell me which is the right place to be brought into notice ?

On Sun, Jan 9, 2011 at 4:22 PM, Siddu <siddu.sjce@gmail.com> wrote:
> Hi all,
> Recently i have gotten around with the habit of testing release
> candidate builds out of the linus's tree .
> Here is something strange which seems to happening with 2.6.37-rc8+
> also i am not sure if this existed earlier .
> Upon hibernating and booting back , X display becomes weird and
> unusable , but on normal shutdown/reboot things seem to be fine.
> Here with attaching logs of Xorg.0.log and kern.log
>
> a snippet of kern.log as follows
> Jan  9 11:04:58 x-moto kernel: [ 4554.844761] done.
> Jan  9 11:04:58 x-moto kernel: [ 4554.844780] PM: Basic memory bitmaps freed
> Jan  9 11:04:58 x-moto kernel: [ 4554.844785] video LNXVIDEO:00:
> Restoring backlight state
> Jan  9 11:04:58 x-moto kernel: [ 4554.850370] [drm:drm_mode_getfb]
> *ERROR* invalid framebuffer id
> Jan  9 11:04:58 x-moto kernel: [ 4554.909592] [drm:radeon_ib_schedule]
> *ERROR* radeon: couldn't schedule IB(12).
> Jan  9 11:04:58 x-moto kernel: [ 4554.909596] [drm:radeon_cs_ioctl]
> *ERROR* Failed to schedule IB !
> Jan  9 11:04:58 x-moto kernel: [ 4554.909870] [drm:radeon_ib_schedule]
> *ERROR* radeon: couldn't schedule IB(13).
> Jan  9 11:04:58 x-moto kernel: [ 4554.909873] [drm:radeon_cs_ioctl]
> *ERROR* Failed to schedule IB !
> Jan  9 11:04:58 x-moto kernel: [ 4555.005941] [drm:radeon_ib_schedule]
> *ERROR* radeon: couldn't schedule IB(14).
> Jan  9 11:04:58 x-moto kernel: [ 4555.005945] [drm:radeon_cs_ioctl]
> *ERROR* Failed to schedule IB !
> Jan  9 11:04:58 x-moto kernel: [ 4555.007755] [drm:radeon_ib_schedule]
> *ERROR* radeon: couldn't schedule IB(15).
> Jan  9 11:04:58 x-moto kernel: [ 4555.007758] [drm:radeon_cs_ioctl]
> *ERROR* Failed to schedule IB !
> Jan  9 11:04:58 x-moto kernel: [ 4555.010712] [drm:radeon_ib_schedule]
> *ERROR* radeon: couldn't schedule IB(0).
> Jan  9 11:04:58 x-moto kernel: [ 4555.010716] [drm:radeon_cs_ioctl]
> *ERROR* Failed to schedule IB !
>
> --
> Regards,
> ~Sid~
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> - - - - - -
> Gazing through the window at the world outside,
> Wondering will mother earth survive ?
> Hoping that the mankind will stop abusing her
> Sometime !
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> - - - - - -
>



-- 
Regards,
~Sid~
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- - - - - -
Gazing through the window at the world outside,
Wondering will mother earth survive ?
Hoping that the mankind will stop abusing her
Sometime !
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- - - - - -
