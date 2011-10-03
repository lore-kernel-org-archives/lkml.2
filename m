Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1JCRBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:01:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54439 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941Ab1JCRB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:01:27 -0400
Date: Mon, 3 Oct 2011 18:01:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: samsung: s3c-i2s-v2.c needs module.h
Message-ID: <20111003170121.GR3731@opensource.wolfsonmicro.com>
References: <1317562466.4996.2.camel@phoenix>
 <20111002182605.GC2857@opensource.wolfsonmicro.com>
 <CAF+7xWkfTJXwt1uUtXgkh5Go9yxWasdM5a3DuLnii_5LqB00UQ@mail.gmail.com>
 <20111003103026.GB23811@sirena.org.uk>
 <4E89DCC7.4010703@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89DCC7.4010703@windriver.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 12:03:19PM -0400, Paul Gortmaker wrote:
> On 11-10-03 06:30 AM, Mark Brown wrote:

> > That's exactly what I'm running at the minute with no problem...

> Then I'm guessing you don't have the option for it enabled (as

I'm pretty sure I'd have noticed if I wasn't building the driver, my
systems would be a lot less noisy than it currently is.

> Thanks Axel, I'll squish this into the commit that adds module.h
> to all the other sound drivers that have it missing.

Now that we've worked out what it's for I don't see any reason not to
apply Axel's patch right now so I've done that.

It would be useful if you could send your patches for module.h
upstream, there's no reason to avoid sending them now and it'd be useful
to cut down on the noise from small merge issues.
