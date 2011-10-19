Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1JSRAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:00:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34491 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab1JSRAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:00:01 -0400
Date: Wed, 19 Oct 2011 17:59:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v6 1/2] ASoC: da7210: Add support for mute
 and zero cross controls
Message-ID: <20111019165952.GA23788@opensource.wolfsonmicro.com>
References: <1319014146.7230.47.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319014146.7230.47.camel@matrix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 02:19:06PM +0530, Ashish Chavan wrote:
> This patch adds support for below set of controls,
> (1) Mute controls for MIC, AUX and ADC
> (2) Zero cross controls for head phone, AUX, INPGA and line out
> (3) Head phone mode selection - class H or G

Applied, thanks.
