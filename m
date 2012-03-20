Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2CTSII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:08:08 -0400
Received: from mail.solarflare.com ([216.237.3.220]:64915 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752604Ab2CTSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:08:06 -0400
Message-ID: <1332266881.2489.4.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v2] ethernet driver for the WIZnet W5300 chip
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mike Sinkovsky <msink@permonline.ru>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 20 Mar 2012 18:08:01 +0000
In-Reply-To: <1332149037-12025-1-git-send-email-msink@permonline.ru>
References: <1332149037-12025-1-git-send-email-msink@permonline.ru>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18784.004
X-TM-AS-Result: No--9.997200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 14:23 +0500, Mike Sinkovsky wrote:
> Based on original driver from chip manufacturer, but with many cleanups.
> Hope now it is near to mainline kernel quality.
> 
> Tested and used in production with Blackfin BF531 embedded processor.
[...]
> +static void w5300_get_drvinfo(struct net_device *ndev,
> +			      struct ethtool_drvinfo *info)
> +{
> +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
> +	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
[...]

Nitpick: if you don't have firmware, don't set fw_version at all.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

