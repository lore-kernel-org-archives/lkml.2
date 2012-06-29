Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2F2P4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:56:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51702 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab2F2P4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:56:03 -0400
X-Sasl-enc: df1kYVo8CHw5eLLPMhex4yHFyVRYSWrAzsjcmloVb3fl 1340985361
Date: Fri, 29 Jun 2012 11:55:59 -0400
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: linux-next: manual merge of the staging tree with the trivial
 tree
Message-ID: <20120629155559.GA21039@kroah.com>
References: <20120629155724.99c0b8d8ad0738fdc7ebca33@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629155724.99c0b8d8ad0738fdc7ebca33@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 03:57:24PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/comedi/drivers/s626.h between commit 6ac7d11527a3
> ("treewide: Put a space between #include and FILE") from the trivial tree
> and commit 90fd56af25b7 ("staging: comedi: s626: remove private INLINE
> macro") from the staging tree.
> 
> Just context changes.  I fixed it up and can carry the fix as necessary.

Sounds fine with me, thanks.

greg k-h
