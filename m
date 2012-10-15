Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2JOS7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:59:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33785 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2JOS7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:59:36 -0400
Date: Mon, 15 Oct 2012 11:59:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d reverts
 unrelated changes
Message-ID: <20121015185931.GA5009@kroah.com>
References: <507C475502000078000A17AA@nat28.tlf.novell.com>
 <507C5C04.4040506@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507C5C04.4040506@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 08:55:00PM +0200, Michal Marek wrote:
> Dne 15.10.2012 17:26, Jan Beulich napsal(a):
> > Michal,
> > 
> > is there any reason why that commit reverts two other changes
> > (to arch/x86/Makefile and scripts/Makefile.fwinst) without any
> > mention of the reason for this in the description?
> 
> Oh, I don't know how this could have happened. It seems that I did a git
> commit --amend at some point :-(.

Ok, be sure to mark whatever you do to fix this for also backporting to
the stable tree so I pick it up.

thanks,

greg k-h
