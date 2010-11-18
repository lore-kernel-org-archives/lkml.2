Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab0KRKfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:35:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60480 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755561Ab0KRKfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:35:33 -0500
Date: Thu, 18 Nov 2010 10:35:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        bleong@codeaurora.org
Subject: Re: [PATCH 1/2] drivers: regulator: core: use pr_fmt
Message-ID: <20101118103530.GA7233@rakim.wolfsonmicro.main>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:30:27PM -0800, Daniel Walker wrote:
> This adds a pr_fmt line which uses the __func__ macro. I also
> convert the current pr_ lines to remove their __func__ usage.
> 
> Cc: bleong@codeaurora.org
> Signed-off-by: Daniel Walker <dwalker@codeaurora.org>

Both patches

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
