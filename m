Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1FMRkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:40:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab1FMRka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:40:30 -0400
Message-ID: <4DF64B73.2060800@ti.com>
Date: Mon, 13 Jun 2011 18:40:03 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/3 v2] ASoC: Add ADAU1701 codec driver
References: <1307971582-13532-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1307971582-13532-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/11 14:26, Lars-Peter Clausen wrote:
> This patch adds support for the Analog Devices ADAU1701 SigmaDSP.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> Changes since v1:
> Move the error message for unsupported register addresses to
> adau1701_register_size.
> ---
>  sound/soc/codecs/Kconfig    |    7 +-
>  sound/soc/codecs/Makefile   |    2 +
>  sound/soc/codecs/adau1701.c |  548 +++++++++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/adau1701.h |   17 ++
>  4 files changed, 573 insertions(+), 1 deletions(-)
>  create mode 100644 sound/soc/codecs/adau1701.c
>  create mode 100644 sound/soc/codecs/adau1701.h

Patches 1 & 2

Acked-by: Liam Girdwood <lrg@ti.com>

