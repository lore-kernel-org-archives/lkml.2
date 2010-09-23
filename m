Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0IWQtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:49:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53397 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755428Ab0IWQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:49:22 -0400
Date: Thu, 23 Sep 2010 18:12:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Alan Cox <alan@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20100923181212.422e76c1@lxorguk.ukuu.org.uk>
In-Reply-To: <20100923081350.e028c4ac.rdunlap@xenotime.net>
References: <20100923142018.55019d59.sfr@canb.auug.org.au>
	<20100923141433.GC31738@kroah.com>
	<20100923081350.e028c4ac.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 08:13:50 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Thu, 23 Sep 2010 07:14:33 -0700 Greg KH wrote:
> 
> > On Thu, Sep 23, 2010 at 02:20:18PM +1000, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > After merging the tty tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > drivers/char/ip2/ip2main.c:459: error: 'ip2_get_icount' undeclared here (not in a function)
> > > 
> > > Caused by commit 157be28e51ed476aa357c8718aaef4832f4da66b ("tty: icount
> > > changeover for other main devices").
> > > 
> > > Please build test (especially the trivial "cut and paste" changes) ...
> > > 
> > > I have reverted that commit for today.
> > 
> > Ick, sorry about that.  Alan, care to send a fixup patch for this?
> 
> 
> So developers and maintainers are not doing allmodconfig builds?
> I can understand not doing randconfig builds.

drivers/staging/ti-st/st_kim.c:34:20: error: st_kim.h: No such file or
directory

So there isn't actually much point trying allmodconfig builds (thats not
the only fail either).


