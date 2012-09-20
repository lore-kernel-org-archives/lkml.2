Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2ITCEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:04:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48841 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab2ITCEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:04:15 -0400
Date: Wed, 19 Sep 2012 21:31:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] clk: wm831x: Fix clk_register() error code checking
Message-ID: <20120920013115.GF17666@opensource.wolfsonmicro.com>
References: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org>
 <1348034730-16473-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348034730-16473-2-git-send-email-sboyd@codeaurora.org>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:05:28PM -0700, Stephen Boyd wrote:
> clk_register() returns an ERR_PTR upon failure, not NULL. Fix
> these error paths.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

this is an API change since the driver was sent which the driver didn't
get updatd for.
