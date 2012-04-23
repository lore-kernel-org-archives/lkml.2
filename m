Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2DWQiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:38:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37319 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550Ab2DWQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:38:51 -0400
X-Sasl-enc: O+5IiUJ+EJwTuO30Cs4Htd0sMag3/JUCNUGL5H2mXq8z 1335199130
Date: Mon, 23 Apr 2012 09:38:49 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the usb tree
Message-ID: <20120423163849.GB1988@kroah.com>
References: <20120423151146.8c5687c65c4eab16f063954c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423151146.8c5687c65c4eab16f063954c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 03:11:46PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/comedi/drivers/dt9812.c between commit de15fe3ed9c3
> ("USB: dt9812.c: remove err() usage") from the usb tree and commit
> 73e2918990c0 ("staging: Fix typo in multiple files") from the staging
> tree.
> 
> The former supercedes the latter, so I used that.

Thanks, that sounds correct.

greg k-h
