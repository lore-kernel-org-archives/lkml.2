Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1JSQnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:43:42 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:53164 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756663Ab1JSQnl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <1319014477.7230.53.camel@matrix>
References: <1319014477.7230.53.camel@matrix>
Date: Wed, 19 Oct 2011 17:43:38 +0100
Message-ID: <CABS+qY0FnFk4gomSAvgRiwrVr+WVvqe-pTbicf2pLDcJkN4JZw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v6 2/2] ASoC: da7210: Add support for ALC and
 Noise suppression
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

On 19 October 2011 09:54, Ashish Chavan <ashish.chavan@kpitcummins.com> wrote:
> This patch adds controls to set following ALC parameters,
>  - Max gain, Min gain, Noise gain, Attack rate, Release rate and delay
>
> It also adds a switch to enable/disable noise suppression.
>
> As per DA7210 data sheet, ALC and noise suppression can be enabled
> only if certain conditions are met. This condition checks are handled
> by simply using "_EXT" version of controls to capture change events.
>
> Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> ---
> Changes since v5:
> - Changed error code from -EPERM to EINVAL
> - Used bit fields instead of magic numbers
>
> Changes since v1:
> - Reading from register instead of cache
> - Made debug message more specific about error
> - Changed "Gain" to "Volume" in names of ALC controls
> ---
>  sound/soc/codecs/da7210.c |  110 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 110 insertions(+), 0 deletions(-)
>

Acked-by: Liam Girdwood <lrg@ti.com>

Thanks

Liam
