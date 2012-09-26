Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2IZNzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:55:33 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50641 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab2IZNzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:55:31 -0400
Date: Wed, 26 Sep 2012 08:55:13 -0500
From: key@linux.vnet.ibm.com
To: benh@kernel.crashing.org
Cc: James Morris <jmorris@namei.org>, Ashley Lai <adlai@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, adlai@us.ibm.com, key@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] drivers/char/tpm: remove tasklet and cleanup
Message-ID: <20120926135513.GA8251@ennui.austin.ibm.com>
References: <1345670263.25124.7.camel@footlong>
 <1347472190.27058.5.camel@footlong>
 <alpine.LRH.2.02.1209241225230.678@tundra.namei.org>
 <20120924141041.GA2741@ennui.austin.ibm.com>
 <20120924154821.GA16007@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924154821.GA16007@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092613-9360-0000-0000-00000B0E96EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:48:21AM -0500, key@linux.vnet.ibm.com wrote:
> On Mon, Sep 24, 2012 at 09:10:41AM -0500, key@linux.vnet.ibm.com wrote:
> > On Mon, Sep 24, 2012 at 12:26:05PM +1000, James Morris wrote:
> > > On Wed, 12 Sep 2012, Ashley Lai wrote:
> > > 
> > > > This patch removed the tasklet and moved the wait queue into the
> > > > private structure.  It also cleaned up the response CRQ path.
> > > > 
> > > > Signed-off-by: Ashley Lai <adlai@us.ibm.com>
> > > 
> > > 
> > > Kent: any comment on this?  You should probably push this to me via your 
> > > tree.
> > 
> >   Oh, I thought we were waiting on Ben. This looks good to me, I'll get
> > this to you today.
> 
>   Ashley tells me Ben's review is in the works, so I'll send once we
> have it.

  Ben - any status here?

Kent

> 
> Kent
> 
> > 
> >   Kent
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

