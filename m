Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1JUI6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:58:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43739 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab1JUI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:58:40 -0400
Date: Fri, 21 Oct 2011 09:58:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v7 1/3] ASoC: da7210: Add support for DAPM
Message-ID: <20111021085838.GE3513@opensource.wolfsonmicro.com>
References: <1319119369.24621.84.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319119369.24621.84.camel@matrix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 07:32:49PM +0530, Ashish Chavan wrote:
> This patch adds support for DAPM covering all inputs and outputs
> as well as ADC and DAC.

This patch doesn't apply against current code.

> +/*
> + * DAPM Controls
> + *
> + * Current DAPM implementation covers almost all codec components e.g. IOs,
> + * mixers, PGAs,ADC and DAC.

This explanation would better placed next to the code in the probe -
it's that code which looks out of place in a Linux driver.
