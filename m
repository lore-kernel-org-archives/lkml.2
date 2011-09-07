Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab1IGSpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:45:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32934 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751052Ab1IGSpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:45:00 -0400
Date: Wed, 7 Sep 2011 11:44:57 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/6] regmap: Add a magic bus type to handle quirks of
 analog devices ADIS sensors.
Message-ID: <20110907184457.GC4423@opensource.wolfsonmicro.com>
References: <4E679770.4090008@cam.ac.uk>
 <1315412387-5765-3-git-send-email-jic23@cam.ac.uk>
 <20110907174713.GG2906@opensource.wolfsonmicro.com>
 <4E67B742.6030302@cam.ac.uk>
 <20110907183230.GA4423@opensource.wolfsonmicro.com>
 <4E67BCDF.3020108@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E67BCDF.3020108@cam.ac.uk>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 07:50:07PM +0100, Jonathan Cameron wrote:
> On 09/07/11 19:32, Mark Brown wrote:

> > Either.  Or either expose marshalling or add configuration for the
> > marshalling depending on what's being done, I'm not convinced you need
> > to be working at SPI level at all.

> I'm a little unclear what you mean by 'marshalling'.  Could you expand
> on how that might work?

Marshalling is the process of formatting data for transmit and parsing
it once it's been read in.
