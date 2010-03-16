Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937228Ab0CPAS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:18:56 -0400
Received: from kroah.org ([198.145.64.141]:45723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab0CPASv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:18:51 -0400
Date: Mon, 15 Mar 2010 17:18:37 -0700
From: Greg KH <greg@kroah.com>
To: Ari Entlich <atrigent@ccs.neu.edu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/36] tty: Add a new VT mode which is like VT_PROCESS
 but doesn't require a VT_RELDISP ioctl call
Message-ID: <20100316001837.GB32558@kroah.com>
References: <455171.511691268697128244.JavaMail.root@zimbra>
 <2163366.511711268697190113.JavaMail.root@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2163366.511711268697190113.JavaMail.root@zimbra>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 07:53:10PM -0400, Ari Entlich wrote:
> ----- "Greg KH" <greg@kroah.com> wrote:
> > So, are you happy with this in Linus's tree, or do you want it
> > reverted?
> 
> The problems with this patch include:
> 1. There's at least one subtlety I overlooked - switching between X servers
>    (i.e. from one X VT to another) still requires the cooperation of both
>    X servers. I was assuming that KMS eliminated this.
> 2. It hasn't been tested at all (no X server patch exists which uses the
>    new mode).
> 
> So yes, I think it would be wise to revert it. I'll resubmit the patch (in
> a changed form or otherwise) when I've resolved these issues.
> 
> I apologize again for being late in telling you this stuff.

No problem, I'll go queue up the revert.

thanks,

greg k-h
