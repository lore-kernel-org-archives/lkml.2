Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1I2ACD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:02:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55004 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab1I2ACA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:02:00 -0400
Date: Wed, 28 Sep 2011 17:02:00 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        David Miller <davem@davemloft.net>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] libcrc32c: Expose big-endian version of crc32c
Message-ID: <20110929000200.GR12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com> <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com> <20110928035356.GA6671@gondor.apana.org.au> <20110928165133.GQ12086@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928165133.GQ12086@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 09:51:45AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 28, 2011 at 01:53:59PM +1000, Herbert Xu wrote:
> > On Tue, Sep 27, 2011 at 03:12:53PM -0700, Darrick J. Wong wrote:
> > > Provide a big-endian version of crc32c for modules that want it.
> > 
> > Who is going to use this?
> 
> Well, I was using it for jbd2 ... but since you ask, it seems to work just as
> well with crc32c-le, so I think I'll just drop the -be version.

Drat, it's also missing the gen_crc32ctable program.  Sorry for the noise; I'll
resend it.  With the -be parts stripped out I can remove all but the first
patch, which cuts down the code changes considerably.

--D
