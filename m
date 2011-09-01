Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1IAGli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:41:38 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:55591 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1IAGlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:41:35 -0400
Date: Thu, 1 Sep 2011 14:41:11 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: "'Darrick J. Wong'" <djwong@us.ibm.com>,
        "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
        "'Theodore Tso'" <tytso@mit.edu>,
        "'David Miller'" <davem@davemloft.net>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Mingming Cao'" <cmm@us.ibm.com>,
        "'linux-crypto'" <linux-crypto@vger.kernel.org>,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Message-ID: <20110901064111.GA27893@gondor.apana.org.au>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com> <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 12:40:08AM -0500, Bob Pearson wrote:
> Hi Darrick,
> 
> The same code in crc32.c was helpful to measure performance and help code tuning as well as indicate correctness. Otherwise the code in crypto may be enough to test all the corner cases. If this survives the review I wonder if there is a way to combine crc32 and crc32c together somehow. I like yours because you can load/unload and not need the memory permanently.

You can unload the crypto testmgr module too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
