Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1CAL5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:57:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35706 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752847Ab1CAL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:57:25 -0500
Date: Tue, 1 Mar 2011 11:57:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MAINTAINERS: Remove unnecessary
 linux-kernel@vger.kernel.org entries
Message-ID: <20110301115723.GB9662@opensource.wolfsonmicro.com>
References: <cover.1298439175.git.joe@perches.com>
 <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
 <20110301112038.GA12568@sirena.org.uk>
 <1298980419.4367.18.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298980419.4367.18.camel@Joe-Laptop>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 03:53:39AM -0800, Joe Perches wrote:
> On Tue, 2011-03-01 at 11:20 +0000, Mark Brown wrote:

> > I've run into a noticeable number of issues with users not parsing this
> > convention as expected and sending only direct to maintainer mail for
> > things that have no list.  For the amount of space it saves in the file
> > I'm not sure it's worth removing such entries.

> Yes that's certainly possible, but it's a trade-off given the
> number of people that would not otherwise CC lkml after seeing
> some MAINTAINERS entries with
> L: linux-kernel@vger...
> and some entries without.

Yeah, I'd be in favour of adding back all the other ones that were
removed when the decision to keep the lkml references out of the file
was taken.

> It might also be worthwhile to to update
> Documentation/SubmittingPatches.

It's not actually patches which have been the biggest problem here - a
lot of it has been people with questions about the code or in the
pre-submission stage.
