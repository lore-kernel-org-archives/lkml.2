Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2IED4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:56:42 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44204 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2IED4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:56:39 -0400
X-Auth-Info: 5EoxitFdsFjpDMHKMhJH1BXqV8YjJaXktPDIMrJcrMs=
From: Marek Vasut <marex@denx.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the spi-mb tree with the mmc tree
Date: Wed, 5 Sep 2012 05:56:34 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lauri Hintsala <lauri.hintsala@bluegiga.com>,
        Chris Ball <cjb@laptop.org>
References: <20120905131539.95d7a613d49f741ab6f123a6@canb.auug.org.au>
In-Reply-To: <20120905131539.95d7a613d49f741ab6f123a6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209050556.34563.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Stephen Rothwell,

> Hi Mark,
> 
> Today's linux-next merge of the spi-mb tree got a conflict in
> drivers/mmc/host/mxs-mmc.c between commit fc108d24d3a6 ("mmc: mxs-mmc:
> fix deadlock caused by recursion loop") from the mmc tree and commit
> 829c1bf40b92 ("mmc: spi: Pull out parts shared between MMC and SPI") from
> the spi-mb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

On a quick glance, it seems correct. Thank you!

Best regards,
Marek Vasut
