Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab1EYALP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:11:15 -0400
Received: from mail.perches.com ([173.55.12.10]:1988 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab1EYALP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:11:15 -0400
Subject: Re: [PATCH] checkpatch: Suggest using min_t or max_t
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110524163503.0cd73903.akpm@linux-foundation.org>
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
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 17:11:13 -0700
Message-ID: <1306282273.2298.62.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 16:35 -0700, Andrew Morton wrote:
> On Fri, 20 May 2011 13:24:48 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > A common issue with min() or max() is using a cast on
> > one or both of the arguments when using min_t/max_t could
> > be better.
> > 
> > Add cast detection to uses of min/max and suggest an
> > appropriate use of min_t or max_t instead.
> 
> Causes this:
> 
> akpm2:/usr/src/25> perl scripts/checkpatch.pl patches/drivers-gpio-vx855_gpioc-needs-slabh.patch
> Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at scripts/checkpatch.pl line 271.

Something not making sense here.
I get no report when I try your patch.
(using checkpatch with the regex I sent)

Send the patch again?

$ perl --version

This is perl, v5.10.1 (*) built for i686-linux-gnu-thread-multi
(with 53 registered patches, see perl -V for more detail)

Copyright 1987-2009, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.

$ ./scripts/checkpatch.pl gpio.mbox 
total: 0 errors, 0 warnings, 7 lines checked

gpio.mbox has no obvious style problems and is ready for submission.

