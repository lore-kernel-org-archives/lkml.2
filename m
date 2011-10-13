Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1JMQcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:32:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48922 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135Ab1JMQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:32:11 -0400
Date: Thu, 13 Oct 2011 17:32:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 4/9] ASoC: da7210: Add support for mute
 and zero cross controls
Message-ID: <20111013163208.GL5193@opensource.wolfsonmicro.com>
References: <1318515113.12107.481.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318515113.12107.481.camel@matrix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 07:41:53PM +0530, Ashish Chavan wrote:

> +	SOC_SINGLE("DAC Mute Switch", DA7210_DAC_HPF, 2, 1, 0),

Digital Playback Switch so it matches up with the corresponding Volume
control, though I rather expect that this should in fact be controlled
by the digital_mute() callback for the DAI rather than a control.

Anything called "Foo Mute Switch" is probably doing something wrong as a
switch is already an on/off control.
