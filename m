Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1BPTqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:46:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63032 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1BPTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:46:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sTAb1fYCZpujM5TRKBmJDrZHTbjQaaptx5EkRkcaRwXDenpf43Ix5shZpdOdkLlPRf
         BAyM3s15NoE1MtZ/p05Y2esEIH1x93cLsQNpcx7uFay93k5mkndYsT65Ta5n84rBN7Kk
         3vE8wRGidJuprr0Q5YaA9KFzymsCXIv+3FMa4=
MIME-Version: 1.0
In-Reply-To: <20110216192658.GA7225@blimp.localdomain>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
Date: Wed, 16 Feb 2011 20:46:45 +0100
Message-ID: <AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
From: Alex Riesen <raa.lkml@gmail.com>
To: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 20:26, Alex Riesen <raa.lkml@gmail.com> wrote:
> Linus Torvalds, Wed, Feb 16, 2011 05:16:01 +0100:
>> Most of the changes are pretty spread out and small, with drivers/gpu
>> (radeon and i915) somewhat standing out from the pack. ...
>
> The backlight level on this Dell XPS M1330 reduces every time I reopen
> the lid, and BIOS does not seem to know anything about that (the
> keyboard shortcuts to set backlight brightness cause it to jump to the
> level next to the one set before closing the lid).

It is this bug, I believe:

https://bugzilla.kernel.org/show_bug.cgi?id=25072

I somehow missed it at first, and only noticed after sending the patch.
