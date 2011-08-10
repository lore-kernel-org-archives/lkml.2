Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1HJLSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:18:09 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15940 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753000Ab1HJLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:18:07 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18s4f453efBu7wug2TDO2aq
Date: Wed, 10 Aug 2011 04:18:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Maxin B John <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arch:arm:plat-omap:iovmm: remove unused variable 'va'
Message-ID: <20110810111804.GG1939@atomide.com>
References: <20110808101546.GA25572@maxin>
 <CAMhs6YwHbFknDpOg9e_5XcB-X9qo+DXX3tAaQy5xQopepeKOxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMhs6YwHbFknDpOg9e_5XcB-X9qo+DXX3tAaQy5xQopepeKOxw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Maxin B John <maxin.john@gmail.com> [110810 04:06]:
> ping.

Sorry I've been on vacation, applying to fixes.

Regards,

Tony

 
> On Mon, Aug 8, 2011 at 1:15 PM, Maxin B. John <maxin.john@gmail.com> wrote:
> > The pointer "va" returned from "phys_to_virt(pa)" is never used in
> > "sgtable_fill_kmalloc()".So,it is safe to remove this set-but-unused variable.
> >
> > Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> > ---
> > diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> > index c60737c..79e7fed 100644
> > --- a/arch/arm/plat-omap/iovmm.c
> > +++ b/arch/arm/plat-omap/iovmm.c
> > @@ -423,9 +423,6 @@ static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, u32 da,
> >  {
> >        unsigned int i;
> >        struct scatterlist *sg;
> > -       void *va;
> > -
> > -       va = phys_to_virt(pa);
> >
> >        for_each_sg(sgt->sgl, sg, sgt->nents, i) {
> >                unsigned bytes;
> >
