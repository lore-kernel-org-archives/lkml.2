Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab1JZR1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:27:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47257 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408Ab1JZR1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:27:17 -0400
Date: Wed, 26 Oct 2011 10:16:10 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        David Miller <davem@davemloft.net>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/4] crc32: Bolt on crc32c
Message-ID: <20111026171556.GU12447@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111004235403.1560.55503.stgit@elm3c44.beaverton.ibm.com> <20111021122803.GA15803@gondor.apana.org.au> <20111021165703.GS12447@tux1.beaverton.ibm.com> <20111021191514.GA3997@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021191514.GA3997@gondor.apana.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11102617-8974-0000-0000-0000011F80BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 09:15:14PM +0200, Herbert Xu wrote:
> On Fri, Oct 21, 2011 at 09:57:03AM -0700, Darrick J. Wong wrote:
> > 
> > My patchset builds upon Bob Pearson's crc32 patchset from early September.  Do
> > my patches fail to apply after applying his patchset?
> > 
> > Or, to speed things along, should I simply repost both Bob's and my patches as
> > one big series?
> > 
> > Bob, have you sent out a new iteration of your patches since September 6th?
> 
> I'm fine with you pushing this through whichever tree that Bob's
> patches are going through.

Bob,

Which tree (if any) are your patches going through?  

--D

