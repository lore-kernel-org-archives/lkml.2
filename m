Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1HON3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:29:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56275 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752720Ab1HON3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:29:16 -0400
Date: Mon, 15 Aug 2011 22:29:07 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: soc-jack: Fix checking return value of
 request_any_context_irq
Message-ID: <20110815132905.GG3927@opensource.wolfsonmicro.com>
References: <1313234101.23974.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313234101.23974.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 07:15:01PM +0800, Axel Lin wrote:
> request_any_context_irq() returns a negative value on failure.
> On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.

Applied, thanks.
