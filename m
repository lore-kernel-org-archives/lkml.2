Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1JTQ6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:58:38 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57069 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474Ab1JTQ6h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <1319119369.24621.84.camel@matrix>
References: <1319119369.24621.84.camel@matrix>
Date: Thu, 20 Oct 2011 17:58:36 +0100
Message-ID: <CABS+qY3Fb6Ou+j-TE8Qit-HDx+SRafBoaZfgPs1CegidX2Dv0g@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v7 1/3] ASoC: da7210: Add support for DAPM
From: "Girdwood, Liam" <lrg@ti.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2011 15:02, Ashish Chavan <ashish.chavan@kpitcummins.com> wrote:
> This patch adds support for DAPM covering all inputs and outputs
> as well as ADC and DAC.
>
> Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> ---
> Changes since v3:
> - Added missing routes for In-mixer left and right
> - Added comment explaining rational behind use of STANDBY registers
>
> Changes since v1:
> - used supply widget for mic bias
> - removed mic bias hookup
> - assigned dapm widgets and routes in card struct
> - removed explicit setting of default mixer settings
> - removed explicit setting of ios to standby mode
> ---
>  sound/soc/codecs/da7210.c |  240 ++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 216 insertions(+), 24 deletions(-)
>

Acked-by: Liam Girdwood <lrg@ti.com>
