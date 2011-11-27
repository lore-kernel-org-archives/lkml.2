Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1K0KOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:14:20 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60274 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab1K0KOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:14:18 -0500
X-Sasl-enc: WQ9w+mdaLetgbFYih9wx83TxgN2HdIbVYlchwKDxfJRK 1322388855
Date: Sat, 26 Nov 2011 20:08:33 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Dave Young <dyoung@redhat.com>
Subject: Re: linux-next: manual merge of the tty tree with the tty.current
 tree
Message-ID: <20111127040833.GA7446@kroah.com>
References: <20111118143010.4a6c9eb17b86d24b9ebe706b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118143010.4a6c9eb17b86d24b9ebe706b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 02:30:10PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/tty_ldisc.c between commits df92d0561de3 ("TTY: ldisc, allow
> waiting for ldisc arbitrarily long") and 0c73c08ec73d ("TTY: ldisc, wait
> for ldisc infinitely in hangup") from the tty.current tree and commits
> 66ef27c3fd0e ("tty_ldisc: remove unnecessary negative return check for
> wait_event_timeout") and 8b3ffa173ffa ("TTY: ldisc, remove some unneeded
> includes") from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Now merged together, you shouldn't have to worry about this in the next
tty pull.

thanks,

greg k-h
