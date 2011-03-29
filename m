Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1C2Njz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:39:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58183 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1C2Njy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i9v862MRI8lI2X+70F2BI2DTRhzhXJMmw7DN4jdHauXzMHZTOq33hTy0mnzZT+nOpo
         tIh/NAxuD7eQOKpQJXVKyF4ac3fKNZHIlbSowcm+88Xr1Ap+iGrWRqzfqmWmKFpmN041
         mU05FKLJbnAkvQsA0fNzUOuKBon2pI4VFF62E=
MIME-Version: 1.0
In-Reply-To: <1bdc18$k1kc9s@fmsmga002.fm.intel.com>
References: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk>
	<AANLkTin0bicOYyY2WCaBxN276t5RV-Q9UZVr=WQ6NmQe@mail.gmail.com>
	<1bdc18$k1kc9s@fmsmga002.fm.intel.com>
Date: Tue, 29 Mar 2011 16:39:53 +0300
X-Google-Sender-Auth: h5BU6Swmb0ZKZRH3Y1bx9ufvc3Y
Message-ID: <AANLkTi=Adq8i_qoiHhLB9K-CkUbT8uHZeg-H8Z3_Kgrw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Move the irq wait queue initialisation into the
 ring init
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 4:22 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 29 Mar 2011 16:05:35 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> On Tue, Mar 29, 2011 at 3:23 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > Required so that we don't obliterate the queue if initialising the
>> > rings after the global IRQ handler is installed.
>> >
>> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>
>> I applied both of the patches on top of yesterdays git HEAD and I just
>> get a blank screen after GRUB. No serial or net console here. Do you
>> want me to try just one of the patches or turn on some debugging
>> options?
>
> That was the unspoken side-effect: if we fail to load the i915 module after
> disabling the outputs, then we would be left with a blank screen.
>
> If you can ssh in and retrieve the dmesg, then it should at least give a
> reason...

I have

CONFIG_DRM_I915=y

so there are no modules involved. I'll see if I can ssh to the box.
