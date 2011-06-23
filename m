Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab1FWCcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:32:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:26945 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758391Ab1FWCcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:32:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,410,1304319600"; 
   d="scan'208";a="17202432"
Date: Thu, 23 Jun 2011 10:39:20 +0800
From: Feng Tang <feng.tang@intel.com>
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 00/11] RFC spi-dw updates
Message-ID: <20110623103920.4ecd5ddf@feng-i7>
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

On Thu, 23 Jun 2011 10:00:02 +0800
"dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com> wrote:

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch set contains a number of changes were buried inside of one
> large patch in my last patch set.  The rework of the message/transfer
> handling changes are not part of this patch set.
> 
> 
> This patch set applies after commit ca632f5 on spi/next
> 
> 
> Dirk Brandewie (11):
>   spi-dw: expose platform data stucture.
>   spi-dw: update function naming convention to match file naming
>   spi-dw: change MRST prefix to generic prefix
>   spi-dw: remove unused definition
>   spi-dw: split spi_dw_enable_chip() into
> spi_dw_enable()/spi_dw_disable() spi-dw: Force error on out of range
> chip select. spi-dw: Set number of available chip selects correctly
>   spi-dw: Ensure fifo lenght is set.
>   spi-dw: Fix condition in spi_dw_{writer/reader}
>   spi-dw: Move checking of max_speed_hz value to be a prerequisite in
> spi_dw_setup spi-dw: remove noop else clause

Most of the patches looks good to me, I'll reply to the rest separately.

Thanks,
Feng

> 
>  drivers/spi/spi-dw-mid.c   |   30 +++---
>  drivers/spi/spi-dw-mmio.c  |   38 ++++----
>  drivers/spi/spi-dw-pci.c   |   34 +++---
>  drivers/spi/spi-dw.c       |  247
> ++++++++++++++++++++------------------------
> drivers/spi/spi-dw.h       |   82 ++++++---------
> include/linux/spi/spi-dw.h |   42 ++++++++ 6 files changed, 241
> insertions(+), 232 deletions(-) create mode 100644
> include/linux/spi/spi-dw.h
> 
