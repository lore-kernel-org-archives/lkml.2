Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0GMCrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:47:41 -0400
Received: from kroah.org ([198.145.64.141]:50992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0GMCrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:47:40 -0400
Date: Mon, 12 Jul 2010 19:47:24 -0700
From: Greg KH <greg@kroah.com>
To: Edgardo Hames <ehames@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: wlan-ng: fix checkpatch warnings in
	hfa384x.h
Message-ID: <20100713024724.GB11358@kroah.com>
References: <1278207986-14309-1-git-send-email-ehames@gmail.com> <20100708210244.GA2266@kroah.com> <AANLkTin5QKRuKqklEgnn_UkW6AUbV_5clpFQLeioGdnC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin5QKRuKqklEgnn_UkW6AUbV_5clpFQLeioGdnC@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 10:18:33PM -0300, Edgardo Hames wrote:
> On Thu, Jul 8, 2010 at 6:02 PM, Greg KH <greg@kroah.com> wrote:
> > On Sat, Jul 03, 2010 at 10:46:25PM -0300, Edgardo Hames wrote:
> >> Fixed spaces before tabs, removed unused variables and all typedefs.
> >>
> >> Signed-off-by: Edgardo Hames <ehames@gmail.com>
> >
> > This doesn't apply against the latest linux-next tree, care to respin it
> > and resend both of these?
> 
> Shall I use linux-next/stable to respin the patch? I tried building
> linux-next/master and the module doesn't even build.

Yes please do.  There are patches on the list to get it to build, or you
can just work on the staging-next branch in there to have a buildable
driver.

thanks,

greg k-h
