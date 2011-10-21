Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1JUKYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 06:24:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40000 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab1JUKYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 06:24:32 -0400
Date: Fri, 21 Oct 2011 11:24:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: "Girdwood, Liam" <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v7 2/3] ASoC: da7210: Add support for line
 out and DAC
Message-ID: <20111021102429.GB4080@opensource.wolfsonmicro.com>
References: <1319121769.24621.130.camel@matrix>
 <CABS+qY3zsuQSE_9=_jaoO=AYRyopZ3WPNeG-PJYzwucmWxcqkA@mail.gmail.com>
 <1319186260.24621.154.camel@matrix>
 <20111021090054.GF3513@opensource.wolfsonmicro.com>
 <1319190555.24621.160.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319190555.24621.160.camel@matrix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 03:19:15PM +0530, Ashish Chavan wrote:
> On Fri, 2011-10-21 at 10:00 +0100, Mark Brown wrote:

> > That'd be fine but there's no DAPM code in the patch, only code to
> > unconditionally enable on init.

> Yes, because DAPM part for those IOs is already covered by DAPM patch.

Ah, you should split that out of the DAPM patch into here - the DAPM bit
won't work without the enable bits (as I understand it).
