Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1GKJbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:31:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41379 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1GKJbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:31:41 -0400
Date: Mon, 11 Jul 2011 10:31:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Grant Likely <grant@secretlab.ca>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/6] clk: Initial feedback for off-SoC slow bus clocks
Message-ID: <20110711093124.GA3239@n2100.arm.linux.org.uk>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711025344.GA27497@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:53:44AM +0900, Mark Brown wrote:
> The biggest issue I ran into was that as the clocks are all registered
> by name with the API if you've got two instances of the same off-SoC
> device in the system you'll not be able to disambiguate between the
> clocks it provides.

Sigh.  That sounds like yet more trash.  Obviously whoever thought
up that doesn't actually understand clks.
