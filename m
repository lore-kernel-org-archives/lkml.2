Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1J0KA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 06:00:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33069 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab1J0KAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 06:00:25 -0400
Date: Thu, 27 Oct 2011 12:00:24 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: tlv320aic23: Clear TLV320AIC23_MS_MASTER bit
 for slave mode
Message-ID: <20111027100024.GB22369@opensource.wolfsonmicro.com>
References: <1319704549.2673.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319704549.2673.2.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 04:35:49PM +0800, Axel Lin wrote:
> According to the datasheet:
> 
> Digital Audio Interface Format (07h) register:
> BIT6:	Master/slave mode

Applied both, thanks.
