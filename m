Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147Ab2DLPgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:36:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42399 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab2DLPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:36:43 -0400
Message-ID: <4F86F685.1090707@wwwdotorg.org>
Date: Thu, 12 Apr 2012 09:36:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V4 2/2] staging: iio: add driver for isl29028
References: <1334239266-29505-1-git-send-email-ldewangan@nvidia.com> <1334239266-29505-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1334239266-29505-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 08:01 AM, Laxman Dewangan wrote:
> Intersil's ISL29028 is concurrent Ambient Light and
> Proximity Sensor device.
> Add driver to access the light and IR intensity and

> +static const struct regmap_config isl29028_regmap_config = {
...
> +	.max_register = ISL29028_MAX_REGS - 1,
> +	.num_reg_defaults_raw = ISL29028_MAX_REGS,

This should really be ISL29028_NUM_REGS, since you don't have a maximum
number of registers, just a number of regs.

However, if there's no other reason to respin the patch, don't worry
about it.
