Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0DSMe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:34:56 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52597 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0DSMey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:34:54 -0400
Subject: Re: [PATCH] mc13783-regulator: fix a memory leak in
 mc13783_regulator_remove
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: axel.lin@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <h2t427d64721004181858s4c01a195ma70d3ce96ee2d343@mail.gmail.com>
References: <h2t427d64721004181858s4c01a195ma70d3ce96ee2d343@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 13:34:48 +0100
Message-ID: <1271680488.3208.101.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 09:58 +0800, Axel Lin wrote:
> This patch fixes a memory leak by freeing priv in mc13783_regulator_remove
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/regulator/mc13783-regulator.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

