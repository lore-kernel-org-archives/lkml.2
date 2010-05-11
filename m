Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0EKUFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:05:23 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:53382 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab0EKUFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a4AMklD0pZo8wL1zZ+R70DeEE/wlM3GfLdNvtgW7hMMsagTi2yd37eaMcZvo6EbPxC
         /nXQ9lZyq8vZjBgBdbZstywlIEP6pkJNr1lDXTmHL9xHTmFzqdw5qEfaKATef6WRs2aW
         M0NJx8CF2BJKM/n7LKhCMGlgRszJBMZalY68I=
MIME-Version: 1.0
In-Reply-To: <89khjo$fd2th6@orsmga002.jf.intel.com>
References: <0100511104818.8382a7de.akpm@linux-foundation.org>
	 <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
	 <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com>
	 <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com>
	 <89khjo$fd2th6@orsmga002.jf.intel.com>
Date: Wed, 12 May 2010 01:35:19 +0530
Message-ID: <AANLkTin399EoUPqwNt-ABiBBm0qrPdDrLSAOrA_J6_qf@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On Wed, May 12, 2010 at 1:23 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 12 May 2010 01:08:23 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>> Hello Chris and Andrew,
>>
>> I did further testing and noticed that this patch fixes the boot
>> errors and warnings and I get the XWindows.
>>
>> But XWindows freezes after some time.
>
> The BUG you were hitting before is on the error collection path which
> presumably is still being triggered during boot by a GPU error.

No, I am not getting any bug with your patch.

dmesg with your patch :
http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634-rc7-chris.txt

> Can you check to see if /sys/kernel/debug/dri/0/i915_error_state has
> recorded anything?

No.

> And if not, wait until it freezes and then please file
> a bug report at bugs.freedesktop.org with the i915_error_state, Xorg.0.log
> and dmesg.
>

Ok.

Thanks,
--
Jaswinder Singh.
