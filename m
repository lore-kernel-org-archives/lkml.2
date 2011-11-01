Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1KASzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:55:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44776 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab1KASzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:55:39 -0400
Subject: Re: powerpc 476, Little-endian, pte fault
From: Peter Bergner <bergner@vnet.ibm.com>
To: Santosh Kumar <santoshkumar.a@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        Michael Neuling <mikey@neuling.org>, Ian Munsie <ianmunsi@au1.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJw04pA3mDOgHrOvPxeXR8Fw6Jn1kBz9qSrgq2vJ7HPpyQwSbg@mail.gmail.com>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
	 <12144.1320040276@neuling.org>
	 <CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
	 <20440.1320054588@neuling.org>	<1320060214.30202.34.camel@pasglop>
	 <CAJw04pBpXsTS4=FeG5ZF3nqORXhiOZ=3V60cFCuJfgTiJcCh2g@mail.gmail.com>
	 <1320155074.2996.190.camel@otta>
	 <CAJw04pA3mDOgHrOvPxeXR8Fw6Jn1kBz9qSrgq2vJ7HPpyQwSbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 13:44:53 -0500
Message-ID: <1320173093.2996.244.camel@otta>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
x-cbid: 11110118-1976-0000-0000-0000008EAAD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 22:44 +0530, Santosh Kumar wrote:
> I had a problem configuring the GCC for 476 in little endian mode,

What type of problem?  I assume the binutils you are building
against has 476 support too, correct?  You'll need that.


> So is this PTE fault related to the compiler options?

This could be caused by anything, but I highly doubt this is
caused by a compiler option issue.  My $$ are that you either
have a bug in your kernel patch or there are more places in
the kernel source that need patching.

Peter



