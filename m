Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1JVJhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 05:37:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58328 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab1JVJhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 05:37:47 -0400
Date: Sat, 22 Oct 2011 10:37:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v8 2/3] ASoC: da7210: Add support for line
 out and DAC
Message-ID: <20111022093743.GC3316@opensource.wolfsonmicro.com>
References: <1319204183.24621.265.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319204183.24621.265.camel@matrix>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 07:06:23PM +0530, Ashish Chavan wrote:
> DA7210 has three line outputs. OUT1 Left, OUT1 Right and OUT2 (mono).
> This patch adds support for gain controls for these three line outs.
> It also adds support for overall DAC gain control.

Applied, thanks.
