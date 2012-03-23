Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab2CWRIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:08:35 -0400
Received: from mga12.intel.com ([143.182.124.36]:31967 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755586Ab2CWRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120323132646.9e258a9cf41be00e8a839065@canb.auug.org.au>
References: <20120323132646.9e258a9cf41be00e8a839065@canb.auug.org.au>
Date: Fri, 23 Mar 2012 10:08:32 -0700
Message-ID: <CABE8wwtBLGezYYi65_ZkrCZbt2f_t3LmvyCv3QLDGtTg4c3sJA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the isci tree
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 7:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dan,
>
> After merging the isci tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> drivers/scsi/ipr.c: In function 'ipr_ata_slave_alloc':
> drivers/scsi/ipr.c:4552:28: error: 'ap' undeclared (first use in this function)
>
> Caused by commit 837f52ee7a86 ("libsas, libata: fix start of life for a
> sas ata_port").
>
> I have used the isci tree from next-20120322 for today.

/me kicks himself for overlooking CONFIG_IPR=n in his .config

Fixed up and pushed out.

--
Dan
