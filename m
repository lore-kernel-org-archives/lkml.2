Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0LHQHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:07:30 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:37272 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496Ab0LHQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:07:28 -0500
Date: Wed, 8 Dec 2010 16:07:27 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
Message-ID: <20101208160727.GF10998@console-pimps.org>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com> <20101208115510.GD10998@console-pimps.org> <AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com> <AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 02:21:05PM +0000, Will Newton wrote:
> This adds the mmc host driver for the Synopsys DesignWare mmc
> host controller, found in a number of embedded SoC designs.
> 
> Signed-off-by: Will Newton <will.newton@imgtec.com>
> ---
>  drivers/mmc/host/Kconfig   |   15 +
>  drivers/mmc/host/Makefile  |    1 +
>  drivers/mmc/host/dw_mmc.c  | 1806 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/host/dw_mmc.h  |  153 ++++
>  include/linux/mmc/dw_mmc.h |  149 ++++
>  5 files changed, 2124 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mmc/host/dw_mmc.c
>  create mode 100644 drivers/mmc/host/dw_mmc.h
>  create mode 100644 include/linux/mmc/dw_mmc.h
> 
>  - patch v2: make changes based on review by Matt Fleming.

Reviewed-by: Matt Fleming <matt@console-pimps.org>
