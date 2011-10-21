Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1JUKXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 06:23:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39991 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397Ab1JUKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 06:23:53 -0400
Date: Fri, 21 Oct 2011 11:23:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v7 1/3] ASoC: da7210: Add support for DAPM
Message-ID: <20111021102350.GA4080@opensource.wolfsonmicro.com>
References: <1319119369.24621.84.camel@matrix>
 <20111021085838.GE3513@opensource.wolfsonmicro.com>
 <1319190446.24621.158.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319190446.24621.158.camel@matrix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 03:17:26PM +0530, Ashish Chavan wrote:
> On Fri, 2011-10-21 at 09:58 +0100, Mark Brown wrote:

> > This explanation would better placed next to the code in the probe -
> > it's that code which looks out of place in a Linux driver.

> Only problem with that is the code to enable individual IOs is not at
> one place and is scattered in the probe(). Should I place all such
> things in a single block in probe() and put the comment above that?

That sounds like a good idea - it's fine to split them up per feature
being enabled but if the big comment is in front of all of them that'd
be really helpful.
