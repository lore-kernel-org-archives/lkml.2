Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1HAA3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:29:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44041 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753266Ab1HAA3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:29:39 -0400
Date: Mon, 1 Aug 2011 09:29:34 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header
 change
Message-ID: <20110801002933.GB20641@opensource.wolfsonmicro.com>
References: <1311952766-11693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E3442F9.2060901@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3442F9.2060901@windriver.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 01:44:25PM -0400, Paul Gortmaker wrote:
> On 11-07-29 11:19 AM, Mark Brown wrote:

> > Some header change has removed an implicit include of module.h, breaking
> > the build due to the use of THIS_MODULE. Fix that.

> Thanks, I'll apply it to the module.h cleanup branch that is soaking
> in linux-next.

There's a bunch of other changes fixing issues with this floating around
- Randy Dunlap sent something for a regulator driver the other day and
I've got a couple of other Samsung patches I sent on the basis that this
must have been caused by a change in the Samsung headers.
