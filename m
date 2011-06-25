Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1FYGf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 02:35:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52798 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1FYGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 02:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=ffjGZmyJByB5wTnjz+9R63h8runzN33sp1w8jJCBqPioS+JPT82AMri/Q5sdnBNtGH
         3YeYG+J47X2+XKe8KGdm4uIVgKwxV0Qd8c+vdFYGvuiyMNCa+iMRbhsYGBcx2pmOa9KG
         2kGXmBeyI98Opk/PKSPVynZu6tZC+UFB3W4Vg=
Subject: Re: linux-next: Tree for June 24 (mtd + of)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Vitaly Wool <vwool@ru.mvista.com>
Date: Sat, 25 Jun 2011 09:35:13 +0300
In-Reply-To: <4E04F5D0.9090900@oracle.com>
References: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au>
		 <20110624090456.191f1fda.randy.dunlap@oracle.com>
	 <1308947172.13493.37.camel@koala> <4E04F5D0.9090900@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1308983721.23868.2.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 13:38 -0700, Randy Dunlap wrote:
> On 06/24/11 13:26, Artem Bityutskiy wrote:
> > On Fri, 2011-06-24 at 09:04 -0700, Randy Dunlap wrote:
> >> On Fri, 24 Jun 2011 15:58:22 +1000 Stephen Rothwell wrote:
> >>
> >>> Hi all,
> >>>
> >>> Changes since 20110623:
> >>>
> >>> My fixes tree includes:
> >>> 	(as an experiment) the early part of mmotm-2011-06-22-13-05
> >>> 	STAGING: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE
> >>
> >>
> >> When CONFIG_MTD=m, CONFIG_MTD_OF_PARTS=y:
> >>
> >> drivers/mtd/ofpart.o: In function `init_module':
> >> ofpart.c:(.init.text+0x0): multiple definition of `init_module'
> >> drivers/mtd/mtdcore.o:(.init.text+0x43): first defined here
> > 
> > I guess this is some old issue? I do not think ofpart can be compiled-in
> > if the mtd core is a module...
> 
> [adding driver author, Vitaly]
> 
> No, it's a current issue.

I meant that the subject suggests this is about linux-next, but this
problem should be in upstream.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

