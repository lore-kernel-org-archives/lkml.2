Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab1JDMKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:10:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35437 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166Ab1JDMKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:10:09 -0400
Date: Tue, 4 Oct 2011 13:10:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: wm8994: Slightly optimize configure_clock
Message-ID: <20111004121006.GA6934@opensource.wolfsonmicro.com>
References: <1317730023.17783.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317730023.17783.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 08:07:03PM +0800, Axel Lin wrote:
> snd_soc_update_bits() will only write new register value
> if the old value is different from the new value.
> In additional, snd_soc_update_bits() returns 0 for no change.
> No need to read WM8994_CLOCKING_1 register before calling snd_soc_update_bits().

Applied, thanks.
