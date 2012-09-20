Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2ITBkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:40:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49260 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab2ITBkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:40:12 -0400
Date: Wed, 19 Sep 2012 21:40:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] clk: wm831x: Use devm_clk_register() to simplify code
Message-ID: <20120920014003.GG17666@opensource.wolfsonmicro.com>
References: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org>
 <1348034730-16473-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348034730-16473-4-git-send-email-sboyd@codeaurora.org>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:05:30PM -0700, Stephen Boyd wrote:
> Move this driver to use devm_clk_register() to simplify some
> error paths and reduce lines of code.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
