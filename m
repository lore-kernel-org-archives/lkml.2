Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1IUMvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:51:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40750 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1IUMvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:51:01 -0400
Date: Wed, 21 Sep 2011 13:50:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Drake <dsd@laptop.org>
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 3/3] gpio-vx855: Add device tree binding
Message-ID: <20110921125051.GB25620@sirena.org.uk>
References: <20110921120214.DFDC79D401E@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921120214.DFDC79D401E@zog.reactivated.net>
X-Cookie: Yow!  Am I having fun yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:02:14PM +0100, Daniel Drake wrote:

> +- #gpio-cells : Should be two. The first cell is the pin number and the
> +  second cell is used to specify optional parameters:
> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)

Shouldn't we just have a property for the polarity?
