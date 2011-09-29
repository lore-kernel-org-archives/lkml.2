Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1I2G7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 02:59:19 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:44624 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab1I2G7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 02:59:17 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tlv320dac33: Add guarding parentheses to macros
Date: Thu, 29 Sep 2011 09:59:26 +0300
Message-ID: <3462016.6xldpjznMt@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.4-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317269397.4561.1.camel@phoenix>
References: <1317269397.4561.1.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 September 2011 12:09:57 Axel Lin wrote:
> Put parentheses around macro argument uses. This avoids pitfalls
> for the programmer, where the argument expansion does not give the
> expected result, for example:
> 
> SAMPLES_TO_US(substream->runtime->rate, dac33->uthr - DAC33_MODE7_MARGIN +
> 1);

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
