Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1CKShr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:37:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:25083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1CKShq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,304,1297065600"; 
   d="scan'208";a="896357863"
Date: Fri, 11 Mar 2011 10:36:54 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Milan Broz <mbroz@redhat.com>
Cc: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
Message-ID: <20110311183654.GA3272@tassilo.jf.intel.com>
References: <20110308164508.GA8729@darkside.kls.lan>
 <20110310165730.GC20504@alboin.amr.corp.intel.com>
 <20110310175411.GB25027@darkside.kls.lan>
 <20110311011842.GA5698@alboin.amr.corp.intel.com>
 <20110311180334.GA11382@darkside.kls.lan>
 <4D7A6A26.5000501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A6A26.5000501@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 07:29:58PM +0100, Milan Broz wrote:
> On 03/11/2011 07:03 PM, Mario 'BitKoenig' Holbe wrote:
> 
> >> You probably need to find some way
> >> to make pcrypt (parallel crypt layer) work for dmcrypt. That may
> >> actually give you more speedup too than your old hack because
> >> it can balance over more cores. 
> 
> dmcrypt is already using async crypto interface, it is ready
> for parallelization on this level.
> 
> Perhaps the problem is that pcrypt is not yet implemented for needed
> algorithms?

It needs some glue according to Herbert. I forgot the details.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
