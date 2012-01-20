Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2ATSXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:23:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48059 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837Ab2ATSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:23:08 -0500
Date: Fri, 20 Jan 2012 18:23:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: Add support for multiple s5m devices
Message-ID: <20120120182303.GA18762@opensource.wolfsonmicro.com>
References: <1327043352-25037-1-git-send-email-sbkim73@samsung.com>
 <1327043352-25037-2-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327043352-25037-2-git-send-email-sbkim73@samsung.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:09:12PM +0900, Sangbeom Kim wrote:

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +	switch (s5m87xx->device_type) {
> +	case S5M8751X:
> +		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8751_devs,
> +					ARRAY_SIZE(s5m8751_devs), NULL, 0);
> +		break;

Does the hardware have ID registers you can use to confirm if the user
got the right device?  Cut'n'pasting of machine definitions can be a bit
error prone.
