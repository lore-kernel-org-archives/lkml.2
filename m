Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2LMIs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:48:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47361 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964Ab2LMIs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:48:28 -0500
Date: Thu, 13 Dec 2012 08:48:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT][PATCH 1/4] regulator: core: Allow specify
	activate_[reg|bit] for regmap based voltage_sel operations
Message-ID: <20121213084826.GG27624@opensource.wolfsonmicro.com>
References: <1355388248.31434.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355388248.31434.3.camel@phoenix>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 04:44:08PM +0800, Axel Lin wrote:
> Some DVM regulators needs to update activate_bit after setting vsel_reg to
> initiate voltage change on the output.  This patch adds activate_reg and
> activate_bit to struct regulator_desc and update
> regulator_set_voltage_sel_regmap() to set activate_bit of activate_reg when
> activate_bit is set.

I'm not convinced about the naming here...  how about apply rather than
activate?  Not sure if it shouldn't be specific to voltage setting
either.
