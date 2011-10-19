Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1JSQpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:45:06 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47350 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574Ab1JSQpF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <1319014146.7230.47.camel@matrix>
References: <1319014146.7230.47.camel@matrix>
Date: Wed, 19 Oct 2011 17:45:03 +0100
Message-ID: <CABS+qY32mf+fnWfpEcpc2EZRxwuWCk_BUPhy2d2+YYa4L_QT=Q@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v6 1/2] ASoC: da7210: Add support for mute
 and zero cross controls
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

On 19 October 2011 09:49, Ashish Chavan <ashish.chavan@kpitcummins.com> wrote:
> This patch adds support for below set of controls,
> (1) Mute controls for MIC, AUX and ADC
> (2) Zero cross controls for head phone, AUX, INPGA and line out
> (3) Head phone mode selection - class H or G
>
> It also adds digital_mute() call back.
>
> Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> ---
> Changes since v4:
> - Converted ADC mute controls to a single stereo control
>
> Changes since v2:
> - Added digital_mute() call back and removed control for "DAC Mute
> Switch"
> - Renamed mute control switches
>
> Changes since v1:
> - Changed Mic mute control to a double control
> - Fixed a typo
> ---
>  sound/soc/codecs/da7210.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)

Acked-by: Liam Girdwood <lrg@ti.com>
