Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1KXKv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:51:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59424 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483Ab1KXKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:51:56 -0500
Date: Thu, 24 Nov 2011 10:51:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: sfr@canb.auug.org.au, lrg@slimlogic.co.uk, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de
Subject: Re: [PATCH] regulator: Fix compile break due to missing arguments to
 regulator_register
Message-ID: <20111124105153.GE8470@opensource.wolfsonmicro.com>
References: <1322119637-32634-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322119637-32634-1-git-send-email-rnayak@ti.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 12:57:17PM +0530, Rajendra Nayak wrote:
> The commit 2c043bcbf287 ("regulator: pass additional of_node to
> regulator_register()") caused a compile break because it missed
> updating the regulator_register() call in gpio-regulator.c with
> the additional parameter (NULL).

Applied, thanks.  Please do submit patches against -next.
