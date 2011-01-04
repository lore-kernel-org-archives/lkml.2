Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1ADFaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:30:05 -0500
Received: from kroah.org ([198.145.64.141]:48036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1ADF3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:29:53 -0500
Date: Mon, 3 Jan 2011 21:29:36 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mac Lin <mkl0301@gmail.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the usb tree with the arm tree
Message-ID: <20110104052936.GB14119@kroah.com>
References: <20110104155843.f65f0bcd.sfr@canb.auug.org.au>
 <20110104160708.770eb1e2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104160708.770eb1e2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:07:08PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Tue, 4 Jan 2011 15:58:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/host/ehci-hcd.c between commit
> > 760efe6910d5743084b586d3d0a3b65aea96fb2f ("USB: cns3xxx: Add EHCI and
> > OHCI bus glue for cns3xxx SOCs") from the arm tree and various commits
> > from the usb tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> The fix was not quite right (I left out a "#endif") - I fixed that up.

Thanks for doing this, it looks fine.

greg k-h
