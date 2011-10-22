Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1JVJij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 05:38:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58343 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731Ab1JVJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 05:38:38 -0400
Date: Sat, 22 Oct 2011 10:38:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v8 3/3] ASoC: da7210: Add support for line
 input and mic
Message-ID: <20111022093836.GD3316@opensource.wolfsonmicro.com>
References: <1319204398.24621.274.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319204398.24621.274.camel@matrix>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 07:09:58PM +0530, Ashish Chavan wrote:
> DA7210 has three line inputs (AUX1 Left, AUX1 Right and AUX2) and
> a stereo MIC. This patch adds gain controls for MIC, AUX1, AUX2 as
> well as INPGA. It also adds a control to set  MIC BIAS voltage.

Applied, though the last comment is inaccurate (the micbias should be
managed by kernel code, you removed the control in an earlier revision).
