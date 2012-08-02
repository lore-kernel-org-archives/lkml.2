Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2HBLkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 07:40:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60203 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab2HBLkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:40:49 -0400
Date: Thu, 2 Aug 2012 12:40:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: tps6586x: add support for SYS rail
Message-ID: <20120802114046.GK29157@opensource.wolfsonmicro.com>
References: <1343906193-8309-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343906193-8309-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 04:46:33PM +0530, Laxman Dewangan wrote:

> +static const unsigned int tps6586x_sys_voltages[] = {
> +	5000000,
> +};

Is the system rail actually regulated or is it just a nominal 5V?
Normally it's just the raw, unregulated input switched in with FETs or
whatever.
