Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab1JMQhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:37:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43838 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab1JMQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:37:16 -0400
Date: Thu, 13 Oct 2011 17:37:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 5/9] ASoC: da7210: Add support for other
 DAI word lengths, format and mode
Message-ID: <20111013163713.GM5193@opensource.wolfsonmicro.com>
References: <1318515243.12107.486.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318515243.12107.486.camel@matrix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 07:44:03PM +0530, Ashish Chavan wrote:
> This patchs adds support for following,
> (1) DAI 20 and 32 bit word sizes
> (2) DAI left and right justified formats
> (3) DAI slave mode

Always generate patches against the current development version of the
tree you're submitting against.  I can tell you're not doing that
because I applied this patch yesterday...
