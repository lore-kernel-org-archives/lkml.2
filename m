Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab0JZPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:50:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47207 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab0JZPuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:50:10 -0400
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>
In-Reply-To: <20101026111944.9139ee1b.sfr@canb.auug.org.au>
References: <20101026111944.9139ee1b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 10:50:08 -0500
Message-ID: <1288108208.8283.116.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 11:19 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/lpfc/lpfc_hbadisc.c: In function 'lpfc_mbx_cmpl_fcf_rr_read_fcf_rec':
> drivers/scsi/lpfc/lpfc_hbadisc.c:2332: error: implicit declaration of function 'msleep'
> 
> Caused by commit 2c09c56c0967ff6a0974ebe2b03da39b26073dd0 ("[SCSI] lpfc
> 8.3.18: Add logic to detect last devloss timeout").
> 
> I have used the scsi tree from next-20101025 for today.

I've fixed this up in scsi-misc (by adding an explicit delay.h to
lpfc_hbadisc.c).  So hopefully the scsi branch should work for the next
build.

James



