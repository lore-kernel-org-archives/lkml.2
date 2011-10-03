Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1JCUfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:35:43 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:52698 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1JCUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:35:36 -0400
Date: Mon, 3 Oct 2011 21:35:13 +0100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: djwong@us.ibm.com, Andreas Dilger <adilger.kernel@dilger.ca>,
        Mingming Cao <cmm@us.ibm.com>, David Miller <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Message-ID: <20111003203513.GA10346@gondor.apana.org.au>
References: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com> <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se> <20111003153634.GA12447@tux1.beaverton.ibm.com> <OFA190E2A9.231A7DD6-ONC125791E.006F1765-C125791E.00705758@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFA190E2A9.231A7DD6-ONC125791E.006F1765-C125791E.00705758@transmode.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 10:27:03PM +0200, Joakim Tjernlund wrote:
>
> > > Start from Bobs latest patches and add crc32c to lib/crc32.c
> >
> > If I did that, how should I handle patching in the hardware accelerated version
> > on Intel systems?  That switcheroo ability seems to have been Herbert Xu's
> > motivation for moving crc32c into crypto/ in the first place:
> 
> I don't know, I haven't looked at that problem. I suspect it moved because that
> was the easiest solution. Having an identical impl. of crc32(only the table values differ)
> in crypto compared to the one in lib is not the way forward though.

You can always get crypto/crc32c.c to use call helpers from
lib/crc32.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
