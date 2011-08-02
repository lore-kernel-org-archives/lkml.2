Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1HBEjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:39:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:35703 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab1HBEjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:39:00 -0400
Date: Tue, 2 Aug 2011 00:38:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dave Jones <davej@redhat.com>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header
 change
Message-ID: <20110802043853.GH11811@windriver.com>
References: <1311952766-11693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E3442F9.2060901@windriver.com>
 <20110801002933.GB20641@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110801002933.GB20641@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header change] On 01/08/2011 (Mon 09:29) Mark Brown wrote:

> On Sat, Jul 30, 2011 at 01:44:25PM -0400, Paul Gortmaker wrote:
> > On 11-07-29 11:19 AM, Mark Brown wrote:
> 
> > > Some header change has removed an implicit include of module.h, breaking
> > > the build due to the use of THIS_MODULE. Fix that.
> 
> > Thanks, I'll apply it to the module.h cleanup branch that is soaking
> > in linux-next.
> 
> There's a bunch of other changes fixing issues with this floating around
> - Randy Dunlap sent something for a regulator driver the other day and
> I've got a couple of other Samsung patches I sent on the basis that this
> must have been caused by a change in the Samsung headers.

It is all taken care of, so you don't have to worry.  It isn't a change
specific to any Samsung headers.  If you are interested to know the
background of what is being changed and why, this is a good start.

https://lkml.org/lkml/2011/5/27/459

https://lkml.org/lkml/2011/7/28/12

Thanks,
Paul.
