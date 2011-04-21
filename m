Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1DURWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:22:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57658 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab1DURWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ByNS9SLlpGewMWLzojDQlJydn97CBMW/SMB2fzTBKjAU0/W9O9T+NwFTBltycXGGBo
         OT+ziaOMp+d2+s7C/rer6EUGz23FP5Vqj2qbz6MFPH/hLVB7kcTI5D2h0PI3AqJCNsw6
         37NOZWSf+SyXEwiazv4OYj4Jaepcx/ewH1mTU=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [2.6.39-rc3] Wrong resolution in framebuffer and X Window
Date: Thu, 21 Apr 2011 19:22:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc3; KDE/4.4.5; i686; ; )
Cc: mbroemme@plusserver.de, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201104171804.04664.maciej.rutecki@gmail.com>
In-Reply-To: <201104171804.04664.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211922.05779.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add LKML)

On niedziela, 17 kwietnia 2011 o 18:04:04 Maciej Rutecki wrote:
> Hi
> 
> Last known good: 2.6.38
> Failing kernel: 2.6.39-rc3
> Subsystem: Intel graphics driver.
> 
> Description:
> PC should work with 1440x900 resolution. But console (and after) X Window
> start work with 1024x768.
> 
> I attach dmesg and Xorg.0.log with drm.debug=14 log_buf_len=16M options:
> http://unixy.pl/maciek/download/kernel/2.6.39-rc1/zlom/kms/
> 
> seems that driver cannot detect resolution higher than 1024x768.
> 
> Also I boot kernel replace "i915.modeset=1" with "nomodeset" option:
> http://unixy.pl/maciek/download/kernel/2.6.39-rc1/zlom/nomodeset/
> 
> But then X Window fails to start and got message: "(EE) No devices
> detected."
> 
> Config for 2.6.39-rc3:
> http://unixy.pl/maciek/download/kernel/2.6.39-rc1/zlom/config-2.6.39-rc3
> 
> Best regards

Device:
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express 
Integrated Graphics Controller (rev 02)

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
