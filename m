Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab1JNTl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:41:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33197 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547Ab1JNTl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:41:58 -0400
Date: Fri, 14 Oct 2011 20:41:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3 5/8] ASoC: da7210: Add support for ADC &
 DAC equalizers
Message-ID: <20111014194155.GO2931@opensource.wolfsonmicro.com>
References: <1318590666.12107.524.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318590666.12107.524.camel@matrix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:41:06PM +0530, Ashish Chavan wrote:
> This patch adds support for ADC and DAC five band equalizers
> available on DA7210 codec.

This and some of the others just adding new controls are good but
depend on the DAPM patches which I didn't apply.  I'd suggest
reshuffling them earlier in the series.
