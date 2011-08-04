Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1HDMiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:38:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55284 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754157Ab1HDMil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:38:41 -0400
Date: Thu, 4 Aug 2011 21:26:37 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regulator: tps65023: Setting correct core regulator
 for tps65021
Message-ID: <20110804122635.GD9959@opensource.wolfsonmicro.com>
References: <marcus.folkesson@gmail.com>
 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
 <1312457632-27075-4-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312457632-27075-4-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 01:33:51PM +0200, Marcus Folkesson wrote:
> TPS65023 is using VDCDC1 as core regulator and TPS65021 is using VDCDC3.
> Core-regulator and voltage-tables may differ between
> different regulators. These two is now passed as driver data.
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
