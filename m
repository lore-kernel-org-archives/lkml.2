Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0ICJng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:43:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49126 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752365Ab0ICJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:43:34 -0400
Date: Fri, 3 Sep 2010 10:43:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rklein@nvidia.com
Cc: cbouatmailru@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, achew@nvidia.com,
        khali@linux-fr.org
Subject: Re: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Message-ID: <20100903094332.GB16587@rakim.wolfsonmicro.main>
References: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
X-Cookie: The early worm gets the bird.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 10:29:46AM -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> this driver depends on I2C and uses SMBUS for communication with the host.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
