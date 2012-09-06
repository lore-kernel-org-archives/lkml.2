Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2IFG0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:26:42 -0400
Received: from bluegiga.fi ([194.100.31.45]:41772 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2IFG0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:26:41 -0400
Message-ID: <5048421F.7080101@bluegiga.com>
Date: Thu, 06 Sep 2012 09:26:39 +0300
From: Lauri Hintsala <lauri.hintsala@bluegiga.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Marek Vasut <marex@denx.de>
Subject: Re: linux-next: manual merge of the spi-mb tree with the mmc tree
References: <20120905131539.95d7a613d49f741ab6f123a6@canb.auug.org.au>
In-Reply-To: <20120905131539.95d7a613d49f741ab6f123a6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Sep 2012 06:26:39.0232 (UTC) FILETIME=[92A92000:01CD8BF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 06:15 AM, Stephen Rothwell wrote:
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

Reviewed and tested. Looks good.

Lauri
