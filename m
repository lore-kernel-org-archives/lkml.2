Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2EANqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:46:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56590 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756657Ab2EANqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:46:31 -0400
X-Sasl-enc: ilCD/mlaxA8cGy5EMuKUjjxZY4F7hGegRtwGN6QkM7vW 1335879990
Date: Tue, 1 May 2012 09:46:30 -0400
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: linux-next: manual merge of the driver-core tree with Linus' tree
Message-ID: <20120501134630.GC31954@kroah.com>
References: <20120501150109.753d67c17e5beead1600c7ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501150109.753d67c17e5beead1600c7ac@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 03:01:09PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> init/main.c between commit a99cd1125189 ("init: fix bug where environment
> vars can't be passed via boot args") from Linus' tree and commit
> 9fb48c744ba6 ("params: add 3rd arg to option handler callback signature")
> from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, I was warned about this from Jim, but hadn't had the chance to
do the merge myself.  I'll work on this later today so you don't have to
carry the fix yourself.

greg k-h
