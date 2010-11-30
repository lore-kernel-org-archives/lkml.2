Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0K3OXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:23:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53970 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751233Ab0K3OXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:23:49 -0500
Date: Tue, 30 Nov 2010 14:23:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add and use rdev_<level> macros
Message-ID: <20101130142347.GH7403@rakim.wolfsonmicro.main>
References: <20101129220046.GB8335@opensource.wolfsonmicro.com>
 <3c50480be4c6fe95a01d79e3c95fba0d9175a81b.1291079473.git.joe@perches.com>
 <20101130105205.GA7403@rakim.wolfsonmicro.main>
 <1291125228.18026.32.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291125228.18026.32.camel@Joe-Laptop>
X-Cookie: To teach is to learn.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:53:48AM -0800, Joe Perches wrote:

> Here's an earlier comment:

> On Thu, 2010-11-18 at 13:30 +0000, Mark Brown wrote:
> > This looks reasonable, please rebase on top of Daniel's patches and
> > submit it properly (with changelog and so on). 

> Sometimes it's simpler for an upstream maintainer to do
> something like:

Bearing in mind the above please note that discursive stuff like this
should come after the --- or in a separate mail so that it's separated
from the commit log for tools like git am.  You submit a large number of
patches, you should be aware of things like this.

> git am -s <patch1.mbox>
> patch -p1 < patch2.mbox
> git commit --amend file

> instead of back and forthing.

The other standard approach is to delete patches after review which does
make that rather difficult; resubmission is much more standard than
incremental revisions of unapplied patches and is going to work even if
people are OK with the incremental patches.

> Use rdev_<level> convenience macros to emit rdev_get_name(rdev)
> along with whatever format/arg... is supplied.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
