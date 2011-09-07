Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1IGSMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:12:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60823 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754153Ab1IGSMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:12:47 -0400
Date: Wed, 7 Sep 2011 11:12:37 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/6] SPI: add ability to say we want a cs change after
 every transfer.
Message-ID: <20110907181236.GI2906@opensource.wolfsonmicro.com>
References: <4E679770.4090008@cam.ac.uk>
 <1315412387-5765-2-git-send-email-jic23@cam.ac.uk>
 <20110907173515.GF2906@opensource.wolfsonmicro.com>
 <4E67B477.7060602@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E67B477.7060602@cam.ac.uk>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 07:14:15PM +0100, Jonathan Cameron wrote:
> On 09/07/11 18:35, Mark Brown wrote:

> > We could add this in regmap if required.

> Makes more sense in spi and has been in their 'may be needed comment'
> from the first.  Also, lots of other users who don't fit into regmap
> (because they don't have any registers to speak of :)

Right, but obviously anything doing SPI transfers can just set the flag
in the transfers anyway.  It looked like you were adding this to the
core due to other intervening abstractions, probably this is just a
problem with your changelog.
