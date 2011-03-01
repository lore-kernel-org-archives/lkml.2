Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1CALxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:53:42 -0500
Received: from mail.perches.com ([173.55.12.10]:4003 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab1CALxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:53:41 -0500
Subject: Re: [PATCH 05/18] MAINTAINERS: Remove unnecessary
 linux-kernel@vger.kernel.org entries
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110301112038.GA12568@sirena.org.uk>
References: <cover.1298439175.git.joe@perches.com>
	 <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
	 <20110301112038.GA12568@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 03:53:39 -0800
Message-ID: <1298980419.4367.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 11:20 +0000, Mark Brown wrote:
> On Tue, Feb 22, 2011 at 09:41:58PM -0800, Joe Perches wrote:
> > CC'ing lkml is the default and doesn't need separate entries.
> I've run into a noticeable number of issues with users not parsing this
> convention as expected and sending only direct to maintainer mail for
> things that have no list.  For the amount of space it saves in the file
> I'm not sure it's worth removing such entries.

Yes that's certainly possible, but it's a trade-off given the
number of people that would not otherwise CC lkml after seeing
some MAINTAINERS entries with
L: linux-kernel@vger...
and some entries without.

It might also be worthwhile to to update
Documentation/SubmittingPatches.

Currently, it says to do what you find inappropriate,
direct mails to listed maintainers without cc'ing a list.

It also does not mention scripts/get_maintainer.pl.

-------------------------------------------------------------

5) Select e-mail destination.

Look through the MAINTAINERS file and the source code, and determine
if your change applies to a specific subsystem of the kernel, with
an assigned maintainer.  If so, e-mail that person.

If no maintainer is listed, or the maintainer does not respond, send
your patch to the primary Linux kernel developer's mailing list,
linux-kernel@vger.kernel.org.  Most kernel developers monitor this
e-mail list, and can comment on your changes.

-------------------------------------------------------------


