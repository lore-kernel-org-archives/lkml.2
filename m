Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1I0S0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:26:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36249 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab1I0S0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:26:38 -0400
Date: Tue, 27 Sep 2011 19:26:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
Message-ID: <20110927182636.GR4289@opensource.wolfsonmicro.com>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
 <20110921124936.GA25620@sirena.org.uk>
 <CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
 <20110921131637.GF4374@opensource.wolfsonmicro.com>
 <CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
 <20110927150555.GF20588@ponder.secretlab.ca>
 <CAMLZHHQU-eMAtvBQJj6+WrMjkWWA+ET=z5NdQCEgXxh=m10d3Q@mail.gmail.com>
 <20110927181420.GQ4289@opensource.wolfsonmicro.com>
 <CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 07:25:03PM +0100, Daniel Drake wrote:
> On Tue, Sep 27, 2011 at 7:14 PM, Mark Brown

> > Why not just kmemdup() the template you're using rather than modifying
> > it in place?

> Could do, but is there any point in this case? I'm not seeing it. The
> "template" is already being modified in this way in the current driver
> as well.

That seems like a bug that just happened to get noticed while reviewing
this change, though...
