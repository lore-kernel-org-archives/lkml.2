Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0IHVfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:35:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39747 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab0IHVft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KijsBq0+xzFWq72zxAt19mFvo3yJXyYYFmpQwVQbdr+JRlXcJIw6sxdOfayGeNcKZ0
         oAKSdtjAG+neQEkc4KpDjDswsvCHUOgaqjCXgmCvme9oNtFx/1zSeeTDwuut6Cjkn6X0
         K7dzxOsh5ouxEbjpyFm29yowVnPiUMCVv9/ys=
MIME-Version: 1.0
In-Reply-To: <87iq2gyllg.fsf@spindle.srvr.nix>
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette>
	<87iq2gyllg.fsf@spindle.srvr.nix>
Date: Wed, 8 Sep 2010 17:35:48 -0400
Message-ID: <AANLkTi=ioyeBvN_yiHER7imi9tjGKH3E=jQCbO0NeO-z@mail.gmail.com>
Subject: Re: 2.6.35.*: horrible (exponential? >linear) slowdown to unusability
 (ACPI idle?)
From: John Drescher <drescherjm@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: Damien Wyart <damien.wyart@free.fr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 6 Sep 2010, Damien Wyart uttered the following:
>> So if you can reproduce it quite easily, I guess bisection (even
>
> ha ha ha. I thought I could, but it's intermittent enough to make
> bisection pretty much impossible, and when I gave up and rebooted back
> into 2.6.35.4 the bug went away entirely.
>
> I don't think bisection will work with something this intermittent :/

I believe I have the same problem reported in your first post. Or at
least a lot of the symptoms.

http://forums.gentoo.org/viewtopic-t-842775-postdays-0-postorder-asc-start-0.html

I may try bisecting the kernel if no progress is made on this front in
a few weeks. I am pretty busy at the moment to do much more testing. I
have already spent a few days at this.

John
