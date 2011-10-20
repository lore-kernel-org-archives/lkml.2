Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1JTQyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:54:39 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60820 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824Ab1JTQyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <20111020110214.GC2379@pengutronix.de>
References: <1319107769.8866.3.camel@phoenix>
	<20111020110214.GC2379@pengutronix.de>
Date: Thu, 20 Oct 2011 17:54:37 +0100
Message-ID: <CABS+qY3gdG746vQ4sU-Wbi2x2JGV3O55O6RmdoXax4_prJ3Kkg@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Use SGTL5000_LINREG_VDDD_MASK instead of hardcoded
 mask value
From: "Girdwood, Liam" <lrg@ti.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2011 12:02, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Thu, Oct 20, 2011 at 06:49:29PM +0800, Axel Lin wrote:
>> We have defined SGTL5000_LINREG_VDDD_MASK in sgtl5000.h,
>> use it instead of hardcoded (0x1 << 4) - 1 for the mask.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
>

Acked-by: Liam Girdwood <lrg@ti.com>
