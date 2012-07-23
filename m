Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2GWPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:16:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43400 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601Ab2GWPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:16:55 -0400
X-Sasl-enc: ZmJ4FpSNxNjE9qMSYE7VPf5NxqmhR6Xh6e8vpN5zEWft 1343056615
Date: Mon, 23 Jul 2012 08:16:53 -0700
From: Greg KH <greg@kroah.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Zhi Yong Wu <wuzhy@cn.ibm.com>, David Miller <davem@davemloft.net>,
        kvm-devel <kvm@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the staging tree with the
 target-merge tree
Message-ID: <20120723151653.GB19236@kroah.com>
References: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
 <20120719235523.GA13623@kroah.com>
 <1342806778.25472.1.camel@haakon2.linux-iscsi.org>
 <20120720180358.GA9134@kroah.com>
 <20120720184228.GA19243@redhat.com>
 <20120722020746.GB31926@kroah.com>
 <1342993463.25472.265.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342993463.25472.265.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 02:44:23PM -0700, Nicholas A. Bellinger wrote:
> So Linus has merged target-pending/for-next this afternoon, so now we
> are just waiting on net-next to hit mainline with the vhost patches
> already ACK'ed by MST.  Hopefully that makes things easier for you to
> considering taking tcm_vhost upstream via staging.  ;)
> 
> Also, MST asked for an RFC-v5 for the initial merge commit with some
> minor debug wrapper changes that will be going out next week.  This will
> include a move into drivers/staging/tcm_vhost/ against a rebased
> staging.git patch with the necessary -rc0 mainline dependencies.
> 
> Please let me know if your OK with this, otherwise I'll just plan to
> keep -v5 against target-pending/for-next-merge for now, and send a GIT
> PULL after MST gets back from holiday on the 29th -> 30th.

I have no idea what any of the above three paragraphs are asking for, or
talking about, sorry.

Note, the merge window is closed for taking new stuff into the staging
tree.  If it isn't already in my staging-next tree, it isn't going to go
into 3.6 unless it's bug fixes, sorry.  How about we figure all of this
out after 3.6-rc1 is out so we can understand what is going on for 3.7?

thanks,

greg k-h
