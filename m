Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1BPU2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:28:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63230 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1BPU2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AgBFQa2mNj7avU4v8ggVIVI5eLCra4OirU6613GDQT+Wje5LEByUpsbIv1FjQqAi3I
         eVxV+Ipu+AtlCTQM192qFVqvSa85LXdRRW7U/RynxtkbbEDeJ/Ta7f9uktZ4uH/CtT0p
         X2Ql+U1mVgJXQyYr5RDJhlrJIOtquhrL0bznM=
MIME-Version: 1.0
In-Reply-To: <20110216120518.66dcedff@jbarnes-desktop>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
	<AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
	<20110216115406.631ada72@jbarnes-desktop>
	<AANLkTik+t1A1omh6fh6o_U6mnk6Y3=K+OjnozSmr44Hv@mail.gmail.com>
	<20110216120518.66dcedff@jbarnes-desktop>
Date: Wed, 16 Feb 2011 21:28:49 +0100
Message-ID: <AANLkTin=RmwByxK0Q_w_O3fpqW8BUTW+LdsfjGbq3CNy@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
From: Alex Riesen <raa.lkml@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 21:05, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 16 Feb 2011 20:59:35 +0100
> Alex Riesen <raa.lkml@gmail.com> wrote:
>>
>> I don't think it is related. I don't have problems switching
>> the outputs (frankly, didn't try) and I do have problems
>> restoring backlight, very similar to what I had earlier in
>> 2.6.37.
>
> Right, but it affects the registration of the backlight and ACPI video
> interface as well, so can affect backlight restore on resume.  In my
> case, without the above patch my backlight wouldn't be restored on
> resume, so I'd have to manually echo a value
> into /sys/class/backlight/<foo> to get my display back.

Ok, I tried, but only to find out that my tree already has the
patch (it is in mainline since today). So it definitely
does not help.

Thanks anyway
