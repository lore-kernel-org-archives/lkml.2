Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1LCCar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 21:30:47 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59249 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab1LCCao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 21:30:44 -0500
Date: Fri, 2 Dec 2011 18:30:37 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5.2 00/14] crc32c: Add faster algorithm and self-test
	code
Message-ID: <20111203023037.GA16577@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201202053.GG1495@noexit.corp.google.com> <20111201203122.GC23175@tux1.beaverton.ibm.com> <20111202002358.GA19842@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202002358.GA19842@gondor.apana.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11120302-7182-0000-0000-000000549DF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 08:23:58AM +0800, Herbert Xu wrote:
> On Thu, Dec 01, 2011 at 12:31:22PM -0800, Darrick J. Wong wrote:
> .
> > They seem to call crc32c(), which is in crypto/crc32c.  If you're interested in
> 
> Nope, the crypto API layer will use the SSE implementation
> where available.  Only when it isn't available will the C version
> in crypto/ be used.

There's a SSE version other than what's in crc32c-intel?

(I suspect we're talking about the same thing?)

--D
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

