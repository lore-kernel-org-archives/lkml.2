Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2K1Xis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:38:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:41745 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab2K1Xir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:38:47 -0500
Date: Wed, 28 Nov 2012 15:38:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: TDM bus support in Linux Kernel
Message-ID: <20121128233845.GA16396@kroah.com>
References: <CAKa7sPRgROFY2RfeVW0G_1EWzWXakuWu50tGQ2QuzrvEimU3FQ@mail.gmail.com>
 <20120203110036.GA7732@leaf>
 <F7F628C32E67B04DAECC5CA53521253E5F9D9350@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E5F9D9350@sv-exmb01-lo1.promwad.corp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 11:00:12AM +0000, Kurachkin Michail wrote:
> Hi Greg,
> 
> During the work on developing VoIP network router I designed TDM bus subsystem and wrote SLIC driver for si3226x. This code was developed for the commercial project, and now I am willing to release it under GPL.
> Please review my sources (or give me a clue on what to do next) and give some feedback on my work.
> https://github.com/stelhs/slic_tdm.git

It's really hard to review a random git tree somewhere, and having it in
this form doesn't make it easy to add to the kernel tree itself.

So, could you take your git tree and convert it to a patch (or patches)
to be applied to the kernel.org tree and send it in email so we can see
what it looks like that way?

I'd recommend putting everything under drivers/staging/ for now, to make
it easier to accept at the moment, and it makes it easier to clean up
and fix up any issues in-kernel, instead of having to keep huge patches
outside of the tree.

Take a look at the file, Documentation/SubmittingPatches for how to
create a patch and what I need in order for it to be able to be applied.

thanks,

greg k-h
