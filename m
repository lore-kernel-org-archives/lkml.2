Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2GWTrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:47:12 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:53596 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2GWTrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:47:09 -0400
Subject: Re: linux-next: manual merge of the staging tree with the
 target-merge tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Greg KH <greg@kroah.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Zhi Yong Wu <wuzhy@cn.ibm.com>, David Miller <davem@davemloft.net>,
        kvm-devel <kvm@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <20120723151653.GB19236@kroah.com>
References: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
	 <20120719235523.GA13623@kroah.com>
	 <1342806778.25472.1.camel@haakon2.linux-iscsi.org>
	 <20120720180358.GA9134@kroah.com> <20120720184228.GA19243@redhat.com>
	 <20120722020746.GB31926@kroah.com>
	 <1342993463.25472.265.camel@haakon2.linux-iscsi.org>
	 <20120723151653.GB19236@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jul 2012 12:47:06 -0700
Message-ID: <1343072826.25472.280.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 08:16 -0700, Greg KH wrote:
> On Sun, Jul 22, 2012 at 02:44:23PM -0700, Nicholas A. Bellinger wrote:
> > So Linus has merged target-pending/for-next this afternoon, so now we
> > are just waiting on net-next to hit mainline with the vhost patches
> > already ACK'ed by MST.  Hopefully that makes things easier for you to
> > considering taking tcm_vhost upstream via staging.  ;)
> > 
> > Also, MST asked for an RFC-v5 for the initial merge commit with some
> > minor debug wrapper changes that will be going out next week.  This will
> > include a move into drivers/staging/tcm_vhost/ against a rebased
> > staging.git patch with the necessary -rc0 mainline dependencies.
> > 
> > Please let me know if your OK with this, otherwise I'll just plan to
> > keep -v5 against target-pending/for-next-merge for now, and send a GIT
> > PULL after MST gets back from holiday on the 29th -> 30th.
> 
> I have no idea what any of the above three paragraphs are asking for, or
> talking about, sorry.
> 
> Note, the merge window is closed for taking new stuff into the staging
> tree.  If it isn't already in my staging-next tree, it isn't going to go
> into 3.6 unless it's bug fixes, sorry.

In that case, I'll just keep tcm_vhost in drivers/vhost/ for now and
await MST's return to determine if he's willing to ACK this round (via
target-pending) for an initial merge.

> How about we figure all of this
> out after 3.6-rc1 is out so we can understand what is going on for 3.7?
> 

I'd like to try to avoid slipping to v3.7 if possible, as we'll have the
necessary dependencies in mainline over the next days once net-next is
merged.  It's also self-contained driver that does not effect existing
code (aside from what's already been ACK'ed), so risk is very low..

--nab

