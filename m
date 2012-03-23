Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2CWIUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:20:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33034 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab2CWIUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:20:13 -0400
Message-ID: <1332490809.2801.2.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Garzik <jgarzik@pobox.com>
Date: Fri, 23 Mar 2012 08:20:09 +0000
In-Reply-To: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
References: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
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

That's defined in linux/proc_fs.h

What was the config?  Was it a no-PROCFS config, or is this just
something that needs to be explicitly included?

James


