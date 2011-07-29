Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1G2PRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:17:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1G2PRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:17:01 -0400
Date: Fri, 29 Jul 2011 11:16:52 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header
 change
Message-ID: <20110729151652.GB9156@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	Kukjin Kim <kgene.kim@samsung.com>
References: <1311949618-919-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110729144802.GB1422@redhat.com>
 <20110729150144.GC19118@opensource.wolfsonmicro.com>
 <20110729150851.GA9156@redhat.com>
 <20110729151324.GD19118@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729151324.GD19118@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:13:24PM +0100, Mark Brown wrote:
 > On Fri, Jul 29, 2011 at 11:08:51AM -0400, Dave Jones wrote:
 > > On Fri, Jul 29, 2011 at 04:01:44PM +0100, Mark Brown wrote:
 > 
 > >  > Possibly, but there were a bunch of other failures in the Samsung
 > >  > specific stuff not related to module.h which appeared today. I did run
 > >  > into another non-samsung module.h failure, though.  Mostly I was just
 > >  > surprised stuff like this was showing up so late in the merge window, I
 > >  > didn't spend a lot of time investigating what broke.
 > 
 > > wait, confused. Were you building Linus' tree, or -next ?
 > 
 > -next (given that the merge window is still open it should be emptying
 > out other than bug fixes...).

Ok, I'll let Stephen and/or Paul grab this one then.

	Dave
