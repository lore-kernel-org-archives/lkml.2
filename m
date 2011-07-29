Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1G2PBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:01:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37040 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750789Ab1G2PBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:01:46 -0400
Date: Fri, 29 Jul 2011 16:01:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header
 change
Message-ID: <20110729150144.GC19118@opensource.wolfsonmicro.com>
References: <1311949618-919-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110729144802.GB1422@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729144802.GB1422@redhat.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 10:48:02AM -0400, Dave Jones wrote:
> On Fri, Jul 29, 2011 at 03:26:58PM +0100, Mark Brown wrote:
>  > Some header change has removed an implicit include of module.h, breaking
>  > the build due to the use of THIS_MODULE. Fix that.

> is this dependant on the module.h changes that just got merged in -next
> from Paul Gortmaker ?  If so, it should probably get merged as part of that set.

Possibly, but there were a bunch of other failures in the Samsung
specific stuff not related to module.h which appeared today. I did run
into another non-samsung module.h failure, though.  Mostly I was just
surprised stuff like this was showing up so late in the merge window, I
didn't spend a lot of time investigating what broke.
