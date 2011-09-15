Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab1IOPrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:47:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:56961 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067Ab1IOPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:47:14 -0400
Date: Thu, 15 Sep 2011 08:20:36 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Russell King <rmk+alsa@arm.linux.org.uk>
Cc: Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build
 failure
Message-ID: <20110915072036.GB9509@prithivi.gnumonks.org>
References: <1315991893.17271.2.camel@phoenix>
 <20110914191917.GA30518@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914191917.GA30518@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Wed, Sep 14, 2011 at 08:19:17PM +0100, Russell King wrote:

> neo1973_gta01 was added to the database in October 2006.  Five months
> later, neo1973_gta02 was registered by the same person (Harald Welte),
> and gta02 has been merged.
> 
> Therefore, I suggest that the GTA01 will never be submitted now, moreover
> I suggest that neo1973_gta01 was probably a prototype and neo1973_gta02
> was probably the production platform.

GTA01 was produced in a certain quantity, to be honest I don't remember
the details.  It was not just a prototype but actually sold + shipped to
quite a number of people.

> So I suggest these references should be removed.  If the platform is not
> going to be merged its pointless carrying the baggage around in drivers.
> Maybe Harald can confirm?

I can confirm that I personally definitely will not be working on
merging GTA01 related code.  However, the remaining "wider Openmoko
community" is surprisingly active, and I wouldn't be surprised at all if
somebody still wanted to do that, despite all that time having passed.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
