Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab1BXI1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:27:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61093 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab1BXI1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:27:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SoBzLGtNBxFse/ugRItkmB/z+YsG0N+maRpGZaZLha8KzgNGWM1xD2eN7NHFFc2aer
         4GVuU59F9+FxJBhGfAA+xDp9PlEBu/Inj0ImLcr02vxwhQrZb3UriGuASPKYB4tHvqMb
         A9o5dK3jGAnui/4Jyx9pOk7NHmM1Dt2UDgvXQ=
MIME-Version: 1.0
In-Reply-To: <0d30dc$l7ehaa@orsmga001.jf.intel.com>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
	<AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
	<0d30dc$l7ehaa@orsmga001.jf.intel.com>
Date: Thu, 24 Feb 2011 09:27:01 +0100
Message-ID: <AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Alex Riesen <raa.lkml@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Indan Zupancic <indan@nul.nu>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 01:13, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 23 Feb 2011 15:58:02 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> >
>> > See bug https://bugzilla.kernel.org/show_bug.cgi?id=27572
>>
>> Any update on that one?
>
> No, reverting that will cause just another bug elsewhere. I need to
> work out how the gpu is not being flushed with a non-pipelined fence
> change.
>
>> There's that whole "return -EINVAL for
>> I915_PARAM_HAS_RELAXED_FENCING" patch thing?
>
> As it turns out this is a bug in the userspace components of the stack for
> gen2 hardware, with lax kernel side enforcement. Daniel has a fix for both.

Chris, could you point us at the patch? I ask because Daniel left a
comment in bug discussion that we should ignore some patch from him,
and there was no mention of anything else.

I'll gladly test a better fix.
