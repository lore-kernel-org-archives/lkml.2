Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2HAUDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:03:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47325 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360Ab2HAUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:03:16 -0400
Date: Wed, 1 Aug 2012 21:03:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: wm8400: Simplify set REGULATOR_MODE_IDLE mode
 in wm8400_dcdc_set_mode
Message-ID: <20120801200312.GQ4483@opensource.wolfsonmicro.com>
References: <1343783711.8776.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343783711.8776.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 09:15:11AM +0800, Axel Lin wrote:

> To set REGULATOR_MODE_IDLE mode, what we do is to clear DC1_ACTIVE and
> DC1_SLEEP bits, this can be done in one wm8400_set_bits() call.

Applied, thanks.
