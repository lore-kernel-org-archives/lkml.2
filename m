Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1CGJXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:23:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:49434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab1CGJXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:23:39 -0500
Subject: Re: [PATCH v2] matroxfb: remove incorrect Matrox G200eV support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: djwong@us.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Gary Hade <garyhade@us.ibm.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110304202905.GB27190@tux1.beaverton.ibm.com>
References: <20110301175026.GA18770@us.ibm.com>
	 <AANLkTikwSXN8VgDaoUqfHcxoTNxW9uA4D2fUtRLuLbHo@mail.gmail.com>
	 <20110304202905.GB27190@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 19:59:16 +1100
Message-ID: <1299488356.9759.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 12:29 -0800, Darrick J. Wong wrote:
> This is all quite strange -- 2.5 years ago when I wrote the patch it
> seemed to
> work ok.  On newer revisions of the x3650M2 it seems broken.  The
> original
> machine I wrote it for was cut up ages ago.
> 
> I suppose we could simply blacklist any G200eV with a subsystem vendor
> ID of
> 0x1014 (IBM) until we figure out how to correct the driver.  Our
> customers will
> be deprived, but as it seems to be broken across most of our product
> lines I
> doubt any of them are making serious use of it anyway. :)
> 
> Something like this? 

Does X work with the open source drivers ? In that case a better
approach would be to try to figure out what's different between the way
the 2 drivers setup the card registers and fix matroxfb..

Cheers,
Ben.


