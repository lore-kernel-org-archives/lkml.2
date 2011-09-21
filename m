Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1IUQhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:37:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38373 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753115Ab1IUQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:37:42 -0400
Date: Wed, 21 Sep 2011 17:37:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 3/3] gpio-vx855: Add device tree binding
Message-ID: <20110921163738.GK4374@opensource.wolfsonmicro.com>
References: <20110921120214.DFDC79D401E@zog.reactivated.net>
 <20110921125051.GB25620@sirena.org.uk>
 <20110921162906.GY7781@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921162906.GY7781@ponder.secretlab.ca>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 10:29:06AM -0600, Grant Likely wrote:
> On Wed, Sep 21, 2011 at 01:50:52PM +0100, Mark Brown wrote:

> > Shouldn't we just have a property for the polarity?

> A flags cell in gpio specifiers (and irq specifiers for that matter) is
> well established practice.

Oh, well :(  We need to establish what the general style is for stuff
like this, it feels like there's frequent conflict between existing
practice and what people want to do with new bindings (in addition to
the cases like the arrays where there's some issues in general).
