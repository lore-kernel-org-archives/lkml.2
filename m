Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab2HIS5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:57:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43453 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759193Ab2HIS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:57:05 -0400
Date: Thu, 9 Aug 2012 19:57:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] regulator: core: request only valid gpio pins for
 regulator enable
Message-ID: <20120809185701.GD24328@opensource.wolfsonmicro.com>
References: <1344522780-32079-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344522780-32079-1-git-send-email-m.szyprowski@samsung.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:33:00PM +0200, Marek Szyprowski wrote:
> Commit 65f735082de3 ("regulator: core: Add core support for GPIO controlled
> enable lines") introduced enable gpio entry in regulator configuration
> structure. Some drivers use '-1' as a placeholder for marking that such
> gpio line is not available, because '0' is considered as a valid gpio
> number. This patch fixes initialization of such drivers (like MAX8952
> on UniversalC210 board), when '-1' is provided as enable gpio pin in the
> regulator's platform data.

Applied, thanks.
