Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0HIIYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:24:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40871 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0HIIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:24:16 -0400
Subject: Re: [PATCH] regulator: Default GPIO controlled WM8994 regulators
 to disabled
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        stable@kernel.org
In-Reply-To: <1281106104-6079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1281106104-6079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 09:24:12 +0100
Message-ID: <1281342252.3035.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 15:48 +0100, Mark Brown wrote:
> From: Joonyoung Shim <jy0922.shim@samsung.com>
> 
> This ensures that if the GPIO was not enabled prior to the driver
> starting the regulator API will insert the required powerup ramp
> delay when it enables the regulator.  The gpiolib API does not
> provide this information.
> 
> [Rewrote changelog to describe the actual change -- broonie.]
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

