Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1JCNQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:16:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44791 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411Ab1JCNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:16:00 -0400
Date: Mon, 3 Oct 2011 14:15:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix setting update bits for
 WM8741_DACRMSB_ATTENUATION
Message-ID: <20111003131558.GH3731@opensource.wolfsonmicro.com>
References: <1317611341.5065.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317611341.5065.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 11:09:01AM +0800, Axel Lin wrote:
> After checking the code and datasheet, I think what we want in the second
> snd_soc_update_bits call is to update WM8741_DACRMSB_ATTENUATION register
> instead of WM8741_DACRLSB_ATTENUATION.

Applied, thanks.
