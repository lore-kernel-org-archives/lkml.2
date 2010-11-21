Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0KUQ7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:59:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61359 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0KUQ7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Ftjgrtaef1G3lZJpYJqzrpE8w/bLGYRd6YZr9ecZc7xMvgnqRtORpuBwToq1QVSr3T
         0AzFrM7LSngpSU344/fyz10Qm0HkNGVBX7y1EoF0ccfol/2eYsg2u6Bopp4fan+ntXCH
         GT8/2bcBX78zhWK6nCaPlWu4TaLaCqkGo+1j4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Kjell Rune Skaaraas <kjella79@yahoo.no>
Subject: Re: Regression: DisplayPort stops working between 2.6.37-rc1 and rc2
Date: Sun, 21 Nov 2010 17:59:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <452269.51735.qm@web27103.mail.ukl.yahoo.com>
In-Reply-To: <452269.51735.qm@web27103.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011211759.27467.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 17 listopada 2010 o 17:45:54 Kjell Rune Skaaraas wrote:
> I couldn't find a smaller list for graphics, so here goes. Between
> 2.6.37-rc1 and 2.6.37-rc2 my DisplayPort monitor has stopped working. I
> can reboot between the kernel versions and reproduce this, so it's not due
> to any other package upgrade. If I go into the system settings I now only
> have three ports listed, DisplayPort-0 is missing.
> 
> This is on a Radeon HD5850 using the open source radeon drivers. Kernels
> are Ubuntu kernel PPA mainline builds, all the X11 packages follow the
> xorg-edgers PPA and are close to git. Going from the rc2 change log these
> would be suspects:
> 
> Alex Deucher (5):
>       drm/radeon/kms/evergreen: add missing pm.vblank_sync update in vbl
> handler drm/radeon/kms: make the connector code less verbose
>       drm/radeon/kms: don't disable shared encoders on pre-DCE3 display
> blocks drm/radeon/kms: add support for clock/data path routers
>       drm/radeon/kms: fix thermal sensor reporting on rv6xx
> Michel Dänzer (1):
>       drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.
> Tyson Whitehead (1):
>       drm/radeon/kms: fix bugs in ddc and cd path router code
> 
> I'm not all that great with git so haven't worked out how to pin down what
> commit is actually causing it.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=23482
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
