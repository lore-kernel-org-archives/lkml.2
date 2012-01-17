Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2AQKl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:41:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37301 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab2AQKl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:41:56 -0500
Date: Tue, 17 Jan 2012 10:41:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] regulator: Add devm_regulator_get()
Message-ID: <20120117104153.GA2944@opensource.wolfsonmicro.com>
References: <1326771598-28124-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326771598-28124-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 07:39:58PM -0800, Stephen Boyd wrote:
> Add a resource managed regulator_get() to simplify regulator
> usage in drivers. This allows driver authors to "get and forget"
> about their regulators by automatically calling regulator_put()
> when the driver is detached.

So, I've gone ahead and applied this as it's obviously useful as-is but
it's obviously something that should have a bulk version - I'll probably
add that myself.  We really ought to have release functions too in case
something wants to release the resource earlier, though I can't think
where you'd actually use those.
