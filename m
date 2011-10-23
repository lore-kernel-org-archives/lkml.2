Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1JWLs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:48:59 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56192 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392Ab1JWLs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:48:58 -0400
X-Sasl-enc: RTqulIAZNW5/f8tFLkWZjujU0/U1K0HeJvh1vph6TFMo 1319370537
Date: Sun, 23 Oct 2011 13:48:51 +0200
From: Greg KH <greg@kroah.com>
To: Ian Kent <raven@themaw.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable-review@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
Message-ID: <20111023114851.GA24676@kroah.com>
References: <20111023062540.684446582@pistachio.kroah.org>
 <1319370078.7876.8.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319370078.7876.8.camel@perseus.themaw.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 07:41:18PM +0800, Ian Kent wrote:
> On Sun, 2011-10-23 at 08:24 +0200, Greg KH wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let us know.
> 
> Yes, as others point out, either the patch needs to be correctly
> backported or the dependent patches need to be pulled in.
> 
> I can do either of these, what would you prefer?

I'd prefer to take the dependant patches, as that would make things sync
up with what is in Linus's tree, I just wanted to get Miklos's and
David's acks that this is the way to go before I did it.

thanks,

greg k-h
