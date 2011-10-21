Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1JUTPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 15:15:39 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:34693 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1JUTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 15:15:37 -0400
Date: Fri, 21 Oct 2011 21:15:14 +0200
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
Message-ID: <20111021191514.GA3997@gondor.apana.org.au>
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111004235403.1560.55503.stgit@elm3c44.beaverton.ibm.com> <20111021122803.GA15803@gondor.apana.org.au> <20111021165703.GS12447@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021165703.GS12447@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 09:57:03AM -0700, Darrick J. Wong wrote:
> 
> My patchset builds upon Bob Pearson's crc32 patchset from early September.  Do
> my patches fail to apply after applying his patchset?
> 
> Or, to speed things along, should I simply repost both Bob's and my patches as
> one big series?
> 
> Bob, have you sent out a new iteration of your patches since September 6th?

I'm fine with you pushing this through whichever tree that Bob's
patches are going through.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
