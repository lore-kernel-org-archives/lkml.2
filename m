Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1ISSEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:04:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38794 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755590Ab1ISSEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:04:32 -0400
Date: Mon, 19 Sep 2011 19:04:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 0/6 v5] Introduce caching support for regmap
Message-ID: <20110919180430.GE540@opensource.wolfsonmicro.com>
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <20110919175948.GD540@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919175948.GD540@opensource.wolfsonmicro.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 06:59:48PM +0100, Mark Brown wrote:

> So, it's really excellent to have this functionality and as it's mostly
> there I've applied this.  As a followup to this I'll post a short series
> which updates things so they work for my test system plus an additional
> driver conversion, I'll squash some of them down into the original
> commits for bisection and leave others separate.  Thanks for doing this
> work, and thanks also to Lars-Peter for his review and testing.

Oh, and I do expect there's a few other things that need to be tidied up
and improved but it's easier to do so incrementally than re-review the
whole series repeatedly.
