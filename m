Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0HRLaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 07:30:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35346 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0HRLa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 07:30:27 -0400
Date: Wed, 18 Aug 2010 12:30:23 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add additional attribute
 #defines
Message-ID: <20100818113023.GR6193@shadowen.org>
References: <20100811163505.GB26497@redhat.com>
 <1281547748.3976.41.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281547748.3976.41.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:29:08AM -0700, Joe Perches wrote:
> On Wed, 2010-08-11 at 12:35 -0400, Dave Jones wrote:
> > I just got this from a patch I merged..
> > 
> > ERROR: need consistent spacing around '*' (ctx:WxV)
> > #121: FILE: arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c:113:
> > +static struct pcc_cpu __percpu *pcc_cpu_info;
> >                                 ^
> > which doesn't seem right.
> 
> Perhaps these need to be added to checkpatch.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This one looks sane to me, I've pulled this into my tree.  The version
at the URL below should contain it for testing:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
