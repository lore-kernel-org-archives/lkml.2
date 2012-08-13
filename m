Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2HMMbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:31:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51596 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab2HMMbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:31:34 -0400
Date: Mon, 13 Aug 2012 13:31:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/6] regulator: ab3100: Remove get_voltage implementation
 for regulator_ops_fixed
Message-ID: <20120813123132.GD13446@opensource.wolfsonmicro.com>
References: <1344562353.2996.1.camel@phoenix>
 <1344562424.2996.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344562424.2996.2.camel@phoenix>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 09:33:44AM +0800, Axel Lin wrote:
> This is not required after commit f7df20ec
> "regulator: core: Use list_voltage() to read single voltage regulators"

applied 2-6.
