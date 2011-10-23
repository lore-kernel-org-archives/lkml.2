Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1JWMHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:07:10 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50795 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab1JWMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:07:08 -0400
X-Sasl-enc: IzNhy5kOgfA4NmmZ7LhhJ8PKtPkFfqRdDVILmkbf26XC 1319371627
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
From: Ian Kent <raven@themaw.net>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable-review@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Chuck Ebbert <cebbert@redhat.com>
In-Reply-To: <20111023114851.GA24676@kroah.com>
References: <20111023062540.684446582@pistachio.kroah.org>
	 <1319370078.7876.8.camel@perseus.themaw.net>
	 <20111023114851.GA24676@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 20:07:00 +0800
Message-ID: <1319371620.7876.17.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-23 at 13:48 +0200, Greg KH wrote:
> On Sun, Oct 23, 2011 at 07:41:18PM +0800, Ian Kent wrote:
> > On Sun, 2011-10-23 at 08:24 +0200, Greg KH wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let us know.
> > 
> > Yes, as others point out, either the patch needs to be correctly
> > backported or the dependent patches need to be pulled in.
> > 
> > I can do either of these, what would you prefer?
> 
> I'd prefer to take the dependant patches, as that would make things sync
> up with what is in Linus's tree, I just wanted to get Miklos's and
> David's acks that this is the way to go before I did it.

Sure, just let me know if you want me to do any of the leg work (or
keyboard work in this case, ;)).

Ian

