Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0EXWDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:03:01 -0400
Received: from kroah.org ([198.145.64.141]:46903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab0EXWCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:02:24 -0400
Date: Mon, 24 May 2010 14:43:56 -0700
From: Greg KH <greg@kroah.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
       Dan Carpenter <error27@gmail.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] KEYS: Return more accurate error codes
Message-ID: <20100524214356.GH16655@kroah.com>
References: <20100517134235.19013.90388.stgit@warthog.procyon.org.uk>
 <alpine.LRH.2.00.1005180851180.21768@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1005180851180.21768@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 08:51:43AM +1000, James Morris wrote:
> On Mon, 17 May 2010, David Howells wrote:
> 
> > From: Dan Carpenter <error27@gmail.com>
> > 
> > We were using the wrong variable here so the error codes weren't being returned
> > properly.  The original code returns -ENOKEY.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Queued for Linus -- is also likely a -stable candidate.

If so, please just put a:
	Cc: stable <stable@kernel.org>
to the signed-off-by area of the patch.  That way I automatically get
notified when it goes into Linus's tree, and I don't have to go dig and
try to match up a random email reference like this one with the actual
patch in Linus's tree...

thanks,

greg k-h
