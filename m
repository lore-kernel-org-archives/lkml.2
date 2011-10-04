Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1JDFEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 01:04:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:18182 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1JDFEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 01:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,483,1312182000"; 
   d="scan'208";a="74172753"
Subject: Re: [PATCH] ASoC: Remove needless  codec->dapm.bias_level
 assignment to SND_SOC_BIAS_OFF
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <20111003131832.GL3731@opensource.wolfsonmicro.com>
References: <1317644236.2724.1.camel@phoenix>
	 <20111003131832.GL3731@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 10:27:43 +0530
Message-ID: <1317704263.1573.2206.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 14:18 +0100, Mark Brown wrote:
> On Mon, Oct 03, 2011 at 08:17:16PM +0800, Axel Lin wrote:
> > This assignment is done by the snd_soc_register_codec so there is no need
> > to redo it in probe function of a codec driver.
> 
> Axel, please stop CCing Harsha Priya on patches - you should've
> noticed that his address bounces by now.
Hmmm, i can send a patch to update her email id. But for now i dont
think she will work on kernel

-- 
~Vinod

