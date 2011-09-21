Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1IUM4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:56:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49391 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1IUM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:56:09 -0400
Date: Wed, 21 Sep 2011 13:56:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Leo Yan <leoy@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Questions for dummy codec driver
Message-ID: <20110921125607.GC25620@sirena.org.uk>
References: <1316502540.4269.1.camel@phoenix>
 <4E794A96.9040206@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E794A96.9040206@marvell.com>
X-Cookie: Yow!  Am I having fun yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 10:23:18AM +0800, Leo Yan wrote:

> I have a question for the dummy codec.

Don't start new threads by randomly replying to unrelated mails.

> As you know, sometimes maybe we only need set the timing from the
> processor, and codec just only need tx/rx data; So there do not need
> the codec driver.

Even a dumb CODEC will have some constraints on things like the sample
rates it can support which need to be conveyed to the framework and
ideally the audio routing out of the CODEC should be visible for
integration with any external output drivers or similar.

> After browser the code, there have NO such a dummy codec driver; and
> for soc-core, there have not such flags to support this situation.
> Only what i get is sound/soc/codecs/spdif_transciever.c, but it's
> specific for TI's DaVinci platform.

Not at all, what makes you believe that it is platform specific?
