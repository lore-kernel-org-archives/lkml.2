Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2CWIO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:14:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33017 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756335Ab2CWIOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:14:50 -0400
Message-ID: <1332490486.2801.1.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>
Date: Fri, 23 Mar 2012 08:14:46 +0000
In-Reply-To: <1332478202.2882.2.camel@pasglop>
References: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
	 <1332478202.2882.2.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 15:50 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2012-03-23 at 13:00 +1100, Stephen Rothwell wrote:
> > Hi James,
> > 
> > After merging the scsi tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/ata/sata_svw.c: In function 'k2_sata_proc_open':
> > drivers/ata/sata_svw.c:327:2: error: implicit declaration of function 'PDE' [-Werror=implicit-function-declaration]
> > drivers/ata/sata_svw.c:327:56: error: invalid type argument of '->' (have 'int')
> > drivers/ata/sata_svw.c:328:1: warning: control reaches end of non-void function [-Wreturn-type]
> > 
> > Caused by commit 343ac4b031a7 ("[SCSI] sata_svw: convert to scsi proc_ops").
> > 
> > I have used the scsi tree from next-20120322 for today.
> 
> Additionally, I am the author and maintainer of that driver and I don't
> remember ever being CCed on that patch ... or did I miss it ?

You missed it ... I added you and Jeff for automatic cc's when the
commit hit the scsi tree.

This is the mail log:

Mar 22 07:53:17 bedivere postfix/smtp[14322]: C3A1F8EE136: to=<benh@kernel.crashing.org>, relay=gate.crashing.org[63.228.1.57]:25, delay=2.7, delays=0.13/0.12/1.3/1.2, dsn=2.0.0, status=sent (250 2.0.0 q2MErGNT019145 Message accepted for delivery)

James


