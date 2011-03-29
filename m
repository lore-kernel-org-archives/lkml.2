Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1C2XPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:15:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1C2XPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:15:10 -0400
Subject: Re: [PATCH v2] regulator: Add missing platform_set_drvdata in
 tps6105x_regulator_probe
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1301392498.2253.1.camel@phoenix>
References: <1301392498.2253.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 00:15:05 +0100
Message-ID: <1301440505.3402.31.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 17:54 +0800, Axel Lin wrote:
> Otherwise, calling platform_get_drvdata in tps6105x_regulator_remove
> returns NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied.

Thanks

Liam

