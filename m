Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1JUM2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:28:33 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39945 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1JUM2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:28:30 -0400
Date: Fri, 21 Oct 2011 14:28:03 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Darrick J. Wong" <djwong@us.ibm.com>
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
Message-ID: <20111021122803.GA15803@gondor.apana.org.au>
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111004235403.1560.55503.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004235403.1560.55503.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 04:54:03PM -0700, Darrick J. Wong wrote:
> Reuse the existing crc32 code to stamp out a crc32c implementation.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Did you want this to go through my tree? If so then there is a
problem since it doesn't apply at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
