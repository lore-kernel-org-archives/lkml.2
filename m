Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811Ab2D0RFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:05:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55242 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758624Ab2D0RFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:05:38 -0400
X-Sasl-enc: AxH6X+O1Vr9jSfd6Vvd/6q/IyN5Y7XKEC7czi6zINff7 1335546337
Date: Fri, 27 Apr 2012 10:05:36 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20120427170536.GA2789@kroah.com>
References: <20120427143703.f6946999cbca5509e22820a6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427143703.f6946999cbca5509e22820a6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:37:03PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/vt6656/ioctl.c between commit 17b7e1ba1e2e ("staging:
> vt6656: Don't leak memory in drivers/staging/vt6656/ioctl.c::private_ioctl
> ()") from Linus' tree and commit 62ef30b5781d ("staging: vt6656: Remove
> redundant casts from ioctl.c") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, that looks correct.

greg k-h
