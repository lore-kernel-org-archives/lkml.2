Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0G0Kfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:35:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35191 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab0G0Kfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:35:43 -0400
Subject: Re: [PATCH] wm8350-regulator: fix wm8350_register_regulator error
 handling
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <B518CF98-BD06-466C-AD40-BBC4C485C3F4@opensource.wolfsonmicro.com>
References: <1280112118.14256.1.camel@mola>
	 (sfid-20100726_034140_195818_204F7320)  <B518CF98-BD06-466C-AD40-BBC4C485C3F4@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 11:35:38 +0100
Message-ID: <1280226938.3085.23.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-26 at 00:07 -0700, Mark Brown wrote:
> On 25 Jul 2010, at 19:41, Axel Lin <axel.lin@gmail.com> wrote:
> 
> > In the case of platform_device_add() fail, we should call
> > platform_device_put() instead of platform_device_del()
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

