Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621Ab0HMQXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 12:23:17 -0400
Received: from xenotime.net ([72.52.115.56]:49658 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761774Ab0HMQXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 12:23:14 -0400
Date: Fri, 13 Aug 2010 09:23:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org, x86@kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: i386 allmodconfig, current mainline
Message-Id: <20100813092309.fd54fc28.rdunlap@xenotime.net>
In-Reply-To: <AANLkTimtZ7H=rT68V6UGC2GBky8z9VJ5m6-pwFHfm7yw@mail.gmail.com>
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
	<20100810101521.0dcd4393.sfr@canb.auug.org.au>
	<AANLkTimtZ7H=rT68V6UGC2GBky8z9VJ5m6-pwFHfm7yw@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010 18:53:20 +0200 Geert Uytterhoeven wrote:

> On Tue, Aug 10, 2010 at 02:15, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Mon, 9 Aug 2010 16:43:46 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >> Guys.  What's goin' on out there?
> >
> > I guess we are all so up to date that noone does 32 bit builds any
> > more ...  Also noone is bothering to look at the build logs:
> >
> > linus tree: http://kisskb.ellerman.id.au/kisskb/branch/3/
> > linux-next: http://kisskb.ellerman.id.au/kisskb/branch/9/
> 
> Yeah, we have build failures migrating from -next to -linus :-(
> 
> BTW, still no one has commented on http://lkml.org/lkml/2010/7/13/378?

OK.

The diff (regression) script output looks useful to me.
The log summary is still quite (too) verbose, or maybe that's partly due
to the number of warnings & errors.  :(


Maybe someone could look at http://www.xenotime.net/linux/scripts/buildsummary.pl also.

Here is today's linux-next *i386* build summary, short mode (totals only):

> buildsummary.pl -t build*.out | more
build-r5372.out: totals: error/warning files: 27, errors: 3, warnings: 44, Section mismatches: 36
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5373.out: totals: error/warning files: 10, errors: 3, warnings: 14, Section mismatches: 36
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5374.out: totals: error/warning files: 29, errors: 0, warnings: 45, Section mismatches: 38
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5375.out: totals: error/warning files: 18, errors: 3, warnings: 36, Section mismatches: 38
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5377.out: totals: error/warning files: 21, errors: 0, warnings: 43, Section mismatches: 67
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5380.out: totals: error/warning files: 16, errors: 4, warnings: 22, Section mismatches: 81
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5381.out: totals: error/warning files: 17, errors: 3, warnings: 75, Section mismatches: 88
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5383.out: totals: error/warning files: 11, errors: 0, warnings: 32, Section mismatches: 130
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5384.out: totals: error/warning files: 23, errors: 3, warnings: 47, Section mismatches: 150
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5385.out: totals: error/warning files: 6, errors: 12, warnings: 9, Section mismatches: 160
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5386.out: totals: error/warning files: 10, errors: 1, warnings: 53, Section mismatches: 163
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5387.out: totals: error/warning files: 18, errors: 0, warnings: 45, Section mismatches: 164
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5388.out: totals: error/warning files: 7, errors: 1, warnings: 8, Section mismatches: 164
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5389.out: totals: error/warning files: 43, errors: 0, warnings: 80, Section mismatches: 167
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5390.out: totals: error/warning files: 12, errors: 0, warnings: 18, Section mismatches: 167
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5391.out: totals: error/warning files: 46, errors: 0, warnings: 77, Section mismatches: 170
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5392.out: totals: error/warning files: 15, errors: 12, warnings: 31, Section mismatches: 184
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5393.out: totals: error/warning files: 15, errors: 0, warnings: 23, Section mismatches: 187
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5394.out: totals: error/warning files: 76, errors: 0, warnings: 141, Section mismatches: 190
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5395.out: totals: error/warning files: 11, errors: 0, warnings: 18, Section mismatches: 192
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build-r5396.out: totals: error/warning files: 22, errors: 0, warnings: 28, Section mismatches: 193
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
