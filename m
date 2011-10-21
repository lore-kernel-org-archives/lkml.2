Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1JUQ5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:57:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48222 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1JUQ5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:57:11 -0400
Date: Fri, 21 Oct 2011 09:57:03 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        David Miller <davem@davemloft.net>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/4] crc32: Bolt on crc32c
Message-ID: <20111021165703.GS12447@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111004235403.1560.55503.stgit@elm3c44.beaverton.ibm.com> <20111021122803.GA15803@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021122803.GA15803@gondor.apana.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11102116-5806-0000-0000-00000042677A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:28:03PM +0200, Herbert Xu wrote:
> On Tue, Oct 04, 2011 at 04:54:03PM -0700, Darrick J. Wong wrote:
> > Reuse the existing crc32 code to stamp out a crc32c implementation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> Did you want this to go through my tree? If so then there is a
> problem since it doesn't apply at all.

My patchset builds upon Bob Pearson's crc32 patchset from early September.  Do
my patches fail to apply after applying his patchset?

Or, to speed things along, should I simply repost both Bob's and my patches as
one big series?

Bob, have you sent out a new iteration of your patches since September 6th?

--D
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

