Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1IUQ3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:29:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50818 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1IUQ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:29:09 -0400
Date: Wed, 21 Sep 2011 10:29:06 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Drake <dsd@laptop.org>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 3/3] gpio-vx855: Add device tree binding
Message-ID: <20110921162906.GY7781@ponder.secretlab.ca>
References: <20110921120214.DFDC79D401E@zog.reactivated.net>
 <20110921125051.GB25620@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921125051.GB25620@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:50:52PM +0100, Mark Brown wrote:
> On Wed, Sep 21, 2011 at 01:02:14PM +0100, Daniel Drake wrote:
> 
> > +- #gpio-cells : Should be two. The first cell is the pin number and the
> > +  second cell is used to specify optional parameters:
> > +  - bit 0 specifies polarity (0 for normal, 1 for inverted)
> 
> Shouldn't we just have a property for the polarity?

A flags cell in gpio specifiers (and irq specifiers for that matter) is
well established practice.

g.
