Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1JUQzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:55:40 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:48951 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab1JUQzj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:55:39 -0400
MIME-Version: 1.0
In-Reply-To: <1319204183.24621.265.camel@matrix>
References: <1319204183.24621.265.camel@matrix>
Date: Fri, 21 Oct 2011 17:55:38 +0100
Message-ID: <CABS+qY2HAee8BPc0+h9ShwasAO4YkBWpRQ34UYUyyksgOWxVQw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v8 2/3] ASoC: da7210: Add support for line
 out and DAC
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

On 21 October 2011 14:36, Ashish Chavan <ashish.chavan@kpitcummins.com> wrote:
> DA7210 has three line outputs. OUT1 Left, OUT1 Right and OUT2 (mono).
> This patch adds support for gain controls for these three line outs.
> It also adds support for overall DAC gain control.
>
> Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> ---
> Changes since v7:
> - Added DAPM support for OUT1 and OUT2 (Moved here from DAPM patch)
> - Added comment explaining rational behind usage of STANDBY bits
>
> Changes since v1:
> - Removed explicit setting of default gains
> - Renamed "DAC Playback" to "Digital Playback"
> ---
>  sound/soc/codecs/da7210.c |   96 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 96 insertions(+), 0 deletions(-)
>

Acked-by: Liam Girdwood <lrg@ti.com>
