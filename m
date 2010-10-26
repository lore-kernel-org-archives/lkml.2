Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab0JZCXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:23:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42112 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503Ab0JZCXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VdQVJgEEgsfd+76fh3a51gpEi0JmsDwrzAkGAd0cgvMJ3cKRHnfyRvtwLoOH5rbULp
         zxPP1NMhK+rqMRM20gNj07FwRBKNAHieSNc6VzjE4uzDEbj1Ezh1eu2f7tw9s09Q///q
         PrwwRp8b/mHKO984HReJuQwS1w5D7xNYxUNrE=
Subject: Re: [PATCH 22/29] memstick: jmb38x_ms: rework ISR
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <506641.42969.qm@web37602.mail.mud.yahoo.com>
References: <506641.42969.qm@web37602.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:23:19 +0200
Message-ID: <1288059799.4024.172.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:11 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 22/29] memstick: jmb38x_ms: rework ISR
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > New ISR is simplier.
> > Also it only services the hardware when we expect to
> > thus it workarounds the stuck write ready bit hw bug.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> Probably it is.
I am very happy to see you agree at least on this one.

Best regards,
	Maxim Levitsky

