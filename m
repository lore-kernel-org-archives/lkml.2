Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1BPT7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:59:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43539 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1BPT7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=upZE8wQpzxRk5FxQrGv0dZP2/fgRdBrVNaIrABoe4N1AE66bSpCn8VgR539koPJoKO
         VtFPp2mI8qf9zRXjWC5JDSdL2P6rKUy0s8VZ8TLVyu7IdTcdt/Nx2le8RafWw3OtWQ51
         5or2/tpD9jWNsJeevI3ZVsx7uzmTtnUAJ/a4E=
MIME-Version: 1.0
In-Reply-To: <20110216115406.631ada72@jbarnes-desktop>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
	<AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
	<20110216115406.631ada72@jbarnes-desktop>
Date: Wed, 16 Feb 2011 20:59:35 +0100
Message-ID: <AANLkTik+t1A1omh6fh6o_U6mnk6Y3=K+OjnozSmr44Hv@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
From: Alex Riesen <raa.lkml@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 20:54, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 16 Feb 2011 20:46:45 +0100
> Alex Riesen <raa.lkml@gmail.com> wrote:
>> > The backlight level on this Dell XPS M1330 reduces every time I reopen
>> > the lid, and BIOS does not seem to know anything about that (the
>> > keyboard shortcuts to set backlight brightness cause it to jump to the
>> > level next to the one set before closing the lid).
>>
>> It is this bug, I believe:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=25072
>>
>> I somehow missed it at first, and only noticed after sending the patch.
>
> There's also this patch: https://patchwork.kernel.org/patch/499221/.
> It got things working on my E6510 again at least.

I don't think it is related. I don't have problems switching
the outputs (frankly, didn't try) and I do have problems
restoring backlight, very similar to what I had earlier in
2.6.37.
