Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1CKWXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:23:46 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41928 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1CKWXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:23:41 -0500
Date: Fri, 11 Mar 2011 14:23:37 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: djwong@us.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Gary Hade <garyhade@us.ibm.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>, yannick_heneault@matrox.com
Subject: Re: [PATCH v2] matroxfb: remove incorrect Matrox G200eV support
Message-ID: <20110311222337.GC7614@us.ibm.com>
References: <20110301175026.GA18770@us.ibm.com> <AANLkTikwSXN8VgDaoUqfHcxoTNxW9uA4D2fUtRLuLbHo@mail.gmail.com> <20110304202905.GB27190@tux1.beaverton.ibm.com> <1299488356.9759.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299488356.9759.2.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 07:59:16PM +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2011-03-04 at 12:29 -0800, Darrick J. Wong wrote:
> > This is all quite strange -- 2.5 years ago when I wrote the patch it
> > seemed to
> > work ok.  On newer revisions of the x3650M2 it seems broken.  The
> > original
> > machine I wrote it for was cut up ages ago.
> > 
> > I suppose we could simply blacklist any G200eV with a subsystem vendor
> > ID of
> > 0x1014 (IBM) until we figure out how to correct the driver.  Our
> > customers will
> > be deprived, but as it seems to be broken across most of our product
> > lines I
> > doubt any of them are making serious use of it anyway. :)
> > 
> > Something like this? 
> 
> Does X work with the open source drivers ?

Yes, X works fine on at least the IBM System x boxes that have
the Matrox G200eV.

> In that case a better
> approach would be to try to figure out what's different between the way
> the 2 drivers setup the card registers and fix matroxfb..

I suppose someone could attempt this but with vesafb available as
an alternate fb provider and no known demand for repaired G200eV
support in matroxfb, I am not sure what benefit it would provide.

Gary

