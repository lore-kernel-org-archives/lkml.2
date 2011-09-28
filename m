Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1I1Qw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:52:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36121 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1I1Qwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:52:54 -0400
Date: Wed, 28 Sep 2011 09:51:45 -0700
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
Message-ID: <20110928165133.GQ12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com> <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com> <20110928035356.GA6671@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928035356.GA6671@gondor.apana.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11092816-2398-0000-0000-0000008E39FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 01:53:59PM +1000, Herbert Xu wrote:
> On Tue, Sep 27, 2011 at 03:12:53PM -0700, Darrick J. Wong wrote:
> > Provide a big-endian version of crc32c for modules that want it.
> 
> Who is going to use this?

Well, I was using it for jbd2 ... but since you ask, it seems to work just as
well with crc32c-le, so I think I'll just drop the -be version.

--D
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

