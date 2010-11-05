Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab0KEFb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 01:31:27 -0400
Received: from mail.perches.com ([173.55.12.10]:4244 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab0KEFbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 01:31:24 -0400
Subject: Re: [PATCH 36/49] drivers/video: Use vzalloc
From: Joe Perches <joe@perches.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        virtualization@lists.osdl.org
In-Reply-To: <AANLkTinpKni-pfEzo=OwZZePVHapafVHJOydDoDU268_@mail.gmail.com>
References: <cover.1288925424.git.joe@perches.com>
	 <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <a1c4c46381ac1867c4af3edb811e58a721957842.1288925425.git.joe@perches.com>
	 <AANLkTinpKni-pfEzo=OwZZePVHapafVHJOydDoDU268_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 22:31:22 -0700
Message-ID: <1288935082.18440.31.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 13:27 +0800, Dave Young wrote:
> On Fri, Nov 5, 2010 at 11:08 AM, Joe Perches <joe@perches.com> wrote:
> > diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
> > @@ -515,11 +515,10 @@ static int __devinit arcfb_probe(struct platform_device *dev)
> >
> >        /* We need a flat backing store for the Arc's
> >           less-flat actual paged framebuffer */
> > -       if (!(videomemory = vmalloc(videomemorysize)))
> > +       videomemory = vmalloc(videomemorysize);
> typo?

Yes. Thanks for catching that.


