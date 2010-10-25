Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab0JYBae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:30:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37962 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0JYBad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IzKASNULvwmEqbx2bjEfxBiXHW3RV3hYR/64V0Oo57tWD3nulk9xzley7tok2PFJmr
         3S65KWZBXpQDABeCISlMWiN2TzmueZZNJq78uH7QVqR53uREVlUEVvc45YnyJ5h1egGy
         ZPt6QS+1CHP4L2xTCLlRL0dkSjxW/nVNRiAdg=
Subject: Re: [GIT PULL] Revert of the IO stat fix
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1287968152.3976.0.camel@maxim-laptop>
References: <4CC49274.3030803@fusionio.com>
	 <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
	 <4CC49A4B.8010300@fusionio.com> <1287957832.24074.19.camel@maxim-laptop>
	 <AANLkTi=VH03ZL023VT+KYUXKHhZ80TzwqhQeRf17oENG@mail.gmail.com>
	 <1287968152.3976.0.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 03:30:28 +0200
Message-ID: <1287970228.5205.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 02:55 +0200, Maxim Levitsky wrote:
> On Sun, 2010-10-24 at 17:07 -0700, Linus Torvalds wrote:
> > On Sun, Oct 24, 2010 at 3:03 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > >
> > > Btw I had that bug reproduced 100% for all removeable devices I have.
> > > (xD, ms, usb).
> > 
> > Does Jens' suggested patch (the non-revert one) fix your oops? Or only
> > the revert?
> The suggested patch doesn't fix the oops.
> Testing revert now.

Yes, revert works.
Tested xD, MS, USB.


Best regards,
	Maxim Levitsky

> 
> > 
> > IOW, I would want to know whether I could try just merging the fix
> > instead of backing out the patch that looks like a real improvement..
> > 
> >                     Linus
> 
> 


