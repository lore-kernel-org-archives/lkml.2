Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1CQA21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:28:27 -0400
Received: from kroah.org ([198.145.64.141]:60064 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab1CQA2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:28:22 -0400
Date: Wed, 16 Mar 2011 17:28:18 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [GIT PATCH] STAGING patches for .39
Message-ID: <20110317002818.GA19812@kroah.com>
References: <20110316210300.GA3311@kroah.com>
 <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 05:19:47PM -0700, Linus Torvalds wrote:
> On Wed, Mar 16, 2011 at 2:03 PM, Greg KH <greg@kroah.com> wrote:
> > Here is the big staging tree merge for .39
> 
> So I try to compile all the staging drivers every once in a while.
> 
> This time I gave up even trying. After the GMA500 driver didn't
> compile (due to some crazy patch to dri_pci_init() that changes it to
> a calling convention that it has never had), there was another file
> that spewed out about five thousand lines of error/warning messages.
> 
> Aren't those things supposed to at least compile? What's going on?

The gma500 driver will not build until you pull the drm tree into yours
as that is an api dependancy it needs.  I didn't think you build staging
drivers, so I didn't think I needed to call this one out.  I was wrong :)

As for the others, I don't know of any build problems, what one did you
have a problem with?

thanks,

greg k-h
