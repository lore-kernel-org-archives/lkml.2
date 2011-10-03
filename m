Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1JCK3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:29:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60474 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab1JCK25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:28:57 -0400
Date: Mon, 3 Oct 2011 11:28:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree
 node
Message-ID: <20111003102846.GA23811@sirena.org.uk>
References: <20110927150555.GF20588@ponder.secretlab.ca>
 <CAMLZHHQU-eMAtvBQJj6+WrMjkWWA+ET=z5NdQCEgXxh=m10d3Q@mail.gmail.com>
 <20110927181420.GQ4289@opensource.wolfsonmicro.com>
 <CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
 <20110927182636.GR4289@opensource.wolfsonmicro.com>
 <CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
 <20110927183832.GS4289@opensource.wolfsonmicro.com>
 <CAMLZHHRvr-diYGwZ2Kg647Ht7NNb8LEku0pCW8EujRuUeOW5yQ@mail.gmail.com>
 <20110928123154.GG3279@opensource.wolfsonmicro.com>
 <CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
X-Cookie: Batteries not included.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:40:10AM +0100, Daniel Drake wrote:
> On Wed, Sep 28, 2011 at 1:31 PM, Mark Brown
> > Right, but your modification was to the MFD core so it's going to affect
> > other devices...

> But only when they start using the newly added functionality. At this
> point, it affects nobody except vx855.

I'd really expect that if we're adding stuff to the framework then it
should be suitable for random drivers to use.  To be honest I don't
really understand why you're changing the framework at all here, the
child driver is entirely specific to the parent as far as I can see.
