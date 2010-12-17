Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0LQABa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:01:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58001 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab0LQAB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e8SxLdOXbOoisbIEPLYem6TCSXxb6/NP+g0kc4j/gmrzYfDswuLONhERw8iUeAn+AE
         SI88eLuG7ZdBw8fg5Q76/zfkdRZb7gLXZ98ABqVrJppHlSzTlFV9ZWEnioi4xncp0mJI
         6qt+9Scg26dffAqTktMdKhimnoP4kI3KZXO3s=
MIME-Version: 1.0
In-Reply-To: <4D0A9164.5070503@afaics.de>
References: <4D0A9164.5070503@afaics.de>
Date: Fri, 17 Dec 2010 10:01:26 +1000
Message-ID: <AANLkTi=jeJriExzNVRxbApz9VEUeuL0BpVLnRoTx_SrT@mail.gmail.com>
Subject: Re: Intel 82915G/GV/910GL, 2.6.36.2: problem with CONFIG_DRM_I915_KMS=y
From: Dave Airlie <airlied@gmail.com>
To: Harald Dunkel <harri@afaics.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Chris).

On Fri, Dec 17, 2010 at 8:23 AM, Harald Dunkel <harri@afaics.de> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi folks,
>
> according to http://bugs.debian.org/607300 I have to rebuild 2.6.36.2
> with CONFIG_DRM_I915_KMS=y. Problem:
>
> At boot time I get a message "waiting for /dev to be fully populated",
> then the screen goes blank and the monitor enters power save mode.
> 2.6.36.2 without CONFIG_DRM_I915_KMS didn't show this problem.
>
> My grub2 configuration says
>
>        GRUB_GFXMODE=1280x1024
>        GRUB_GFXPAYLOAD_LINUX="keep"
>
> If I comment out these 2 lines and rebuild grub.cfg, then the problem
> goes away, too. I just get a 80x25 display for grub in this case.
>

Is this a regression since 2.6.36 or 2.6.35?

Dave.
