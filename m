Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1HBJTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:19:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54058 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1HBJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:19:11 -0400
Date: Tue, 2 Aug 2011 17:18:56 +0800
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, mchehab@redhat.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        Palash.Bandyopadhyay@conexant.com, ruslan@rpisarev.org.ua,
        Revent82@gmail.com
Subject: Re: [PATCH] Staging: cx25821: fix coding style issues
Message-ID: <20110802171856.044cd78d@inspire>
In-Reply-To: <1312215262.11635.15.camel@Joe-Laptop>
References: <1312191229-24718-1-git-send-email-leonidsbox@gmail.com>
	<1312215262.11635.15.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review. I sent v2. I have a question, however...

On Mon, 01 Aug 2011 09:14:22 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2011-08-01 at 17:33 +0800, Leonid V. Fedorenchik wrote:
> > Fix too long lines in cx25821-audio.h and cx25821-core.c
> []
> > diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
> []
> > @@ -972,8 +972,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
> >  	dev->lmmio = ioremap(dev->base_io_addr, pci_resource_len(dev->pci, 0));
> >  
> >  	if (!dev->lmmio) {
> > -		CX25821_ERR
> > -		    ("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
> > +		CX25821_ERR("ioremap failed, maybe increasing __VMALLOC_RESERVE"
> > +								" in page.h\n");
> 
> Please do not split formats.

What is the reason to not split formats?
I can see that in Documentation/CodingStyle in Chapter 2 it is OK to split
formats if it is not making readability worse.
So, is it for the sake of readability or is it new coding style rule for the
kernel that is not in documentation yet or something else or am I misunderstood
something?

Leonid V. Fedorenchik
