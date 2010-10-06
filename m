Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab0JFCWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:22:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:59989 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0JFCWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:22:18 -0400
Date: Wed, 6 Oct 2010 11:21:46 +0900
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, hch@lst.de,
        hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk,
        bharrosh@panasas.com
Subject: Re: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>
References: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101006111621O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 Oct 2010 11:21:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 15:48:22 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>  drivers/Kconfig                                |    2 +
>  drivers/Makefile                               |    1 +
>  drivers/target/Kbuild                          |   30 +
>  drivers/target/Kconfig                         |   36 +

Why do we need a new place for the target stuff? This could be used
for non scsi protocl?

We had the similar discussion when I put stgt to mainline but we
concluded that under drivers/scsi is the best place.

I don't like to put ibmvscsi driver under something like
drivers/target/tcm_ibmvscsit because ibmvscsi needs to include some
files under drivers/scsi/ibmvscsi/. It's more reasonable to put the
driver there.

Can we change the name, TCM (Target Core Mod), to something more
informative? I think that "Core Mod" is really pointless.

This will be the mainline scsi target feature so why can't we name
the files and modules in more appropriate way?
