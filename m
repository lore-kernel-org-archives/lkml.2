Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2JPGVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:21:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47378 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab2JPGVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:21:06 -0400
Date: Tue, 16 Oct 2012 15:20:14 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] MFD: twl6040: Convert to use regmap_irq
Message-ID: <20121016062011.GF8670@opensource.wolfsonmicro.com>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
 <1349956533-6374-6-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349956533-6374-6-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:55:32PM +0200, Peter Ujfalusi wrote:
> With regmap_irq it is possibole to remove the twl6040-irq.c file and
> simplify the code.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
