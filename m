Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0HTJ0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:26:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37896 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0HTJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:26:43 -0400
Subject: Re: [PATCH] ASoC: e740_wm9705 - free gpio in e740_exit()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Molton <ian@mnementh.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1282200025.9347.1.camel@mola>
References: <1282200025.9347.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 10:26:38 +0100
Message-ID: <1282296398.3084.31.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 14:40 +0800, Axel Lin wrote:
> In e740_init(), we call gpio_request() for
> GPIO_E740_MIC_ON, GPIO_E740_AMP_ON and GPIO_E740_WM9705_nAVDD2.
> We should free the these gpio accordingly in e740_exit().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

