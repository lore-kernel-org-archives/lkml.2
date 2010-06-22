Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab0FVKMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:12:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34286 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab0FVKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:12:24 -0400
Subject: Re: [PATCH v4] alsa: ASoC: Add JZ4740 codec driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       alsa-devel@alsa-project.org
In-Reply-To: <1277160391-14737-1-git-send-email-lars@metafoo.de>
References: <1276958993-9012-1-git-send-email-lars@metafoo.de>
	 <1277160391-14737-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 11:12:19 +0100
Message-ID: <1277201539.4537.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 00:46 +0200, Lars-Peter Clausen wrote:
> This patch adds support for the JZ4740 internal codec.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: alsa-devel@alsa-project.org
> 
> ---
> Changes since v1
> - Put Kconfig entry in alphabetic order
> - Drop codec_set_fmt since the codec supports only one format
> - Rename "Capture Volume" control to "Master Capture Volume"
> - Drop unnecessary format checks
> - Add suspend/resume
> - Cleanup jz4740_codec_set_bias_level
> 
> Changes since v2
> - Drop codec prefix from the filename. Note that I keeped it for the object
>   name, because otherwise when build as a module it will clash with the ASoC
>   JZ4740 platform support.
> 
> Changes since v3
> - Hook up suspend/resume callbacks to the codec instead of the platform device

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

