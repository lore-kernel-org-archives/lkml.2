Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab1EYXyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:54:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737Ab1EYXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:54:18 -0400
Date: Wed, 25 May 2011 16:53:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest using min_t or max_t
Message-Id: <20110525165345.5f775c7b.akpm@linux-foundation.org>
In-Reply-To: <1306282273.2298.62.camel@Joe-Laptop>
References: <4DD50B35.2000005@indesign-llc.com>
	<20110519115859.e11a7ca3.akpm@linux-foundation.org>
	<1305909981.4209.33.camel@Joe-Laptop>
	<20110520095037.25eadc0a.akpm@linux-foundation.org>
	<1305912602.4209.41.camel@Joe-Laptop>
	<20110520103529.1ef3917c.akpm@linux-foundation.org>
	<1305915161.4209.56.camel@Joe-Laptop>
	<20110520113830.3faf5230.akpm@linux-foundation.org>
	<1305923088.4209.79.camel@Joe-Laptop>
	<20110524163503.0cd73903.akpm@linux-foundation.org>
	<1306282273.2298.62.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 17:11:13 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2011-05-24 at 16:35 -0700, Andrew Morton wrote:
> > On Fri, 20 May 2011 13:24:48 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > A common issue with min() or max() is using a cast on
> > > one or both of the arguments when using min_t/max_t could
> > > be better.
> > > 
> > > Add cast detection to uses of min/max and suggest an
> > > appropriate use of min_t or max_t instead.
> > 
> > Causes this:
> > 
> > akpm2:/usr/src/25> perl scripts/checkpatch.pl patches/drivers-gpio-vx855_gpioc-needs-slabh.patch
> > Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at scripts/checkpatch.pl line 271.
> 
> Something not making sense here.
> I get no report when I try your patch.
> (using checkpatch with the regex I sent)
> 
> Send the patch again?
> 
> $ perl --version
> 
> This is perl, v5.10.1 (*) built for i686-linux-gnu-thread-multi
> (with 53 registered patches, see perl -V for more detail)
> 

It happens with perl v5.8.8:

akpm2:/usr/src/25> perl scripts/checkpatch.pl this-file-does-not-exist
Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at scripts/checkpatch.pl line 271.



