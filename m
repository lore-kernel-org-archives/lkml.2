Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2LFGXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:23:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34164 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab2LFGXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:23:04 -0500
Date: Thu, 6 Dec 2012 15:22:58 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Frank Li <Frank.Li@freescale.com>, Lee Jones <lee.jones@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: gpio-regulator: Add ifdef CONFIG_OF guard for
 regulator_gpio_of_match
Message-ID: <20121206062257.GG10867@opensource.wolfsonmicro.com>
References: <1354588325.16068.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354588325.16068.1.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 10:32:05AM +0800, Axel Lin wrote:
> Use of_match_ptr and add ifdef CONFIG_OF guard for regulator_gpio_of_match.

Applied, thanks.
