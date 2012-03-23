Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2CWEuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:50:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:46765 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab2CWEuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:50:21 -0400
Message-ID: <1332478202.2882.2.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
Date: Fri, 23 Mar 2012 15:50:02 +1100
In-Reply-To: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
References: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 13:00 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/ata/sata_svw.c: In function 'k2_sata_proc_open':
> drivers/ata/sata_svw.c:327:2: error: implicit declaration of function 'PDE' [-Werror=implicit-function-declaration]
> drivers/ata/sata_svw.c:327:56: error: invalid type argument of '->' (have 'int')
> drivers/ata/sata_svw.c:328:1: warning: control reaches end of non-void function [-Wreturn-type]
> 
> Caused by commit 343ac4b031a7 ("[SCSI] sata_svw: convert to scsi proc_ops").
> 
> I have used the scsi tree from next-20120322 for today.

Additionally, I am the author and maintainer of that driver and I don't
remember ever being CCed on that patch ... or did I miss it ?

Cheers,
Ben.


