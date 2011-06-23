Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab1FWVhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:37:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1FWVhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:37:04 -0400
Date: Thu, 23 Jun 2011 14:33:15 -0700
From: Greg KH <gregkh@suse.de>
To: Sergiu Iordache <sergiu@chromium.org>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char drivers: Ram oops kernel configuration parameters
Message-ID: <20110623213315.GB4347@suse.de>
References: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
 <62229.1308859172@turing-police.cc.vt.edu>
 <BANLkTiko9PvSDHEnbjCAvcAReLytWwg7qSoZGv778xuj3tqW=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTiko9PvSDHEnbjCAvcAReLytWwg7qSoZGv778xuj3tqW=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 01:43:49PM -0700, Sergiu Iordache wrote:
> On Thu, Jun 23, 2011 at 12:59 PM, <Valdis.Kletnieks@vt.edu> wrote:
> > On Thu, 23 Jun 2011 11:36:00 PDT, Sergiu Iordache said:
> > > Ramoops currently has module parameters for setting the configuration
> > > variables (ram start, ram size and dump oopses). This makes it difficult to
> > > configure when the module is compiled as a builtin.
> >
> > Can't you add 'ramoops.ram_start=128M ramoops.ram_size=64M' or similar
> > to your kernel cmdline?
> 
> You can but the problem is that when you're using the module as a
> builtin managing the command line is harder than managing Kconfig
> files. Instead of having different platform dependent config files
> (which already exist in most of the cases) under source control you
> would have to have different scripts which run the kernel with
> different parameters.

Then why not make the sysfs files writable?

Stuff like this should not be picked from the configuration build if at
all possible.  The fact that you feel changing the Kconfig is easier
than your boot command line shows a problem in your overall system
configuration.

greg k-h
