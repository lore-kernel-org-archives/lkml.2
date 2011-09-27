Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1I0Sik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:38:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37975 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab1I0Sij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:38:39 -0400
Date: Tue, 27 Sep 2011 19:38:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
Message-ID: <20110927183832.GS4289@opensource.wolfsonmicro.com>
References: <20110921124936.GA25620@sirena.org.uk>
 <CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
 <20110921131637.GF4374@opensource.wolfsonmicro.com>
 <CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
 <20110927150555.GF20588@ponder.secretlab.ca>
 <CAMLZHHQU-eMAtvBQJj6+WrMjkWWA+ET=z5NdQCEgXxh=m10d3Q@mail.gmail.com>
 <20110927181420.GQ4289@opensource.wolfsonmicro.com>
 <CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
 <20110927182636.GR4289@opensource.wolfsonmicro.com>
 <CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 07:28:40PM +0100, Daniel Drake wrote:
> On Tue, Sep 27, 2011 at 7:26 PM, Mark Brown

> > That seems like a bug that just happened to get noticed while reviewing
> > this change, though...

> Sorry if I'm missing something obvious but I'm not seeing the issue.
> What exactly is this bug and what effects could it cause?

You're modifying global data which should really be const and is shared
between multiple devices in place.  Probably you'll not notice any
practical effects, especially if you don't happen to have multiple
devices in the same system.
