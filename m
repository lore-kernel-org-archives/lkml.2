Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1JSB1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:27:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1JSB1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 21:27:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=gmNxEVCi9Iv0pozo+yscVz7oHvouSOl9zBRoOGjMtcPs8xsAPdX9Jk1mZHW/Voc7q
	C0TPy9dK9dBZxGKdJRIXA==
Date: Tue, 18 Oct 2011 18:27:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Wolfram Sang <w.sang@pengutronix.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
In-Reply-To: <1318982469.7569.1.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com>
References: <4E9D9558.7040705@cam.ac.uk> <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com> <1318982469.7569.1.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Joe Perches wrote:

> > > This started happening when I run checkpatch on pretty much anything.
> > > triggered by the b in this snipped for example
> > > diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
> > > index 3f8d0af..62dc2a8 100644
> > > --- a/arch/arm/mach-pxa/stargate2.c
> > > +++ b/arch/arm/mach-pxa/stargate2.c
> > > @@ -54,6 +54,8 @@
> > >  #include <linux/mfd/da903x.h>
> > > Anyone else seeing this or have a clue what the heck is going on?
> 
> It's done this since:
> 
> $ git log -1 1e85572697b348b1a126520349a29654f2ae6a12
> commit 1e85572697b348b1a126520349a29654f2ae6a12
> Author: Wolfram Sang <w.sang@pengutronix.de>
> Date:   Tue Jan 6 14:41:24 2009 -0800
> 
>     checkpatch: Add warning for p0-patches
>     

Hmm, not sure how useful that is unless both prefixes ('a' and 'b') exist.
