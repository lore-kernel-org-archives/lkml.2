Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0IJLzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:55:14 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51944 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab0IJLzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:55:12 -0400
Date: Fri, 10 Sep 2010 13:55:11 +0200
From: Florian Mickler <florian@mickler.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Newsgroups: gmane.linux.kernel
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Paolo Ornati <ornati@gmail.com>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon
 DRM KMS related - freezes
Message-ID: <20100910135511.53c0089a@schatten.dmk.lab>
In-Reply-To: <201009091618.51064.Martin@lichtvoll.de>
References: <201008312153.45792.Martin@lichtvoll.de>
	<201009050953.52440.Martin@lichtvoll.de>
	<20100907025110.GD6134@thunk.org>
	<201009091618.51064.Martin@lichtvoll.de>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 16:18:49 +0200
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Yes, I am aware that it may not be a Ext4 problem at all. Thus I said Ext4 
> / readahead related (!) backtrace (! not bug) cause that was all I could 
> see on the screen. How else should I have described that backtrace when I 
> can't speculate on what I can not see?

I think, it is no big thing. The trick is probably to say nothing at all
about the cause, when it is not clear. It's a mind thing. As soon as the
association is brought up, everybody thinks along those lines.  :)

If you leave out the "ext4/readahead related", then people will still
know that it might be ext4 readahead related because you posted the
backtrace, but they will not have their mind turned to that. Instead
they will think: oh a backtrace... there were some people shouting
about backtraces in my area, let's see if it is realted. 

But of course, sometimes putting blame somewhere also does help getting
attention. After all "CORRUPTION IN FILESYSTEM XYZ" sticks out more
than "partial trace of a thing i don't know anything at all".

Cheers,
Flo


