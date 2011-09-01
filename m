Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1IABvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:51:41 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36759 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1IABvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:51:39 -0400
Date: Thu, 1 Sep 2011 11:51:21 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: djwong@us.ibm.com, adilger.kernel@dilger.ca, tytso@mit.edu,
        davem@davemloft.net, linux-kernel@vger.kernel.org, cmm@us.ibm.com,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Message-ID: <20110901015120.GA26182@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <035501cc6845$66a0ad20$33e20760$@systemfabricworks.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Pearson <rpearson@systemfabricworks.com> wrote:
> Could you elaborate a little on this?

Sure, we already have a self-test infrastructure under crypto
in testmgr.*.  It even includes test vectors for crc32c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
