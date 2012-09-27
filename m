Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2I0Ooy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:44:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33576 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab2I0Oow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:44:52 -0400
Message-ID: <1348757203.13546.4.camel@footlong>
Subject: Re: [PATCH 1/1] drivers/char/tpm: remove tasklet and cleanup
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: key@linux.vnet.ibm.com
Cc: benh@kernel.crashing.org, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, adlai@us.ibm.com
Date: Thu, 27 Sep 2012 09:46:43 -0500
In-Reply-To: <20120926135513.GA8251@ennui.austin.ibm.com>
References: <1345670263.25124.7.camel@footlong>
	 <1347472190.27058.5.camel@footlong>
	 <alpine.LRH.2.02.1209241225230.678@tundra.namei.org>
	 <20120924141041.GA2741@ennui.austin.ibm.com>
	 <20120924154821.GA16007@ennui.austin.ibm.com>
	 <20120926135513.GA8251@ennui.austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12092714-5806-0000-0000-00001A05CC79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 08:55 -0500, key@linux.vnet.ibm.com wrote:
> On Mon, Sep 24, 2012 at 10:48:21AM -0500, key@linux.vnet.ibm.com wrote:
> > On Mon, Sep 24, 2012 at 09:10:41AM -0500, key@linux.vnet.ibm.com wrote:
> > > On Mon, Sep 24, 2012 at 12:26:05PM +1000, James Morris wrote:
> > > > On Wed, 12 Sep 2012, Ashley Lai wrote:
> > > > 
> > > > > This patch removed the tasklet and moved the wait queue into the
> > > > > private structure.  It also cleaned up the response CRQ path.
> > > > > 
> > > > > Signed-off-by: Ashley Lai <adlai@us.ibm.com>
> > > > 
> > > > 
> > > > Kent: any comment on this?  You should probably push this to me via your 
> > > > tree.
> > > 
> > >   Oh, I thought we were waiting on Ben. This looks good to me, I'll get
> > > this to you today.
> > 
> >   Ashley tells me Ben's review is in the works, so I'll send once we
> > have it.
> 
>   Ben - any status here?
> 
> Kent

Hi Ben,

Would you review the patch before the weekend?  If you are busy and not
able to review the patch this week, we will pull the patch into James's
tree next week.  I can resolve any additional comments you may have in a
different patch.

Thanks,
--Ashley Lai

> 
> > 
> > Kent
> > 
> > > 
> > >   Kent
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 


