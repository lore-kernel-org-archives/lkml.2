Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0JEWbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:31:42 -0400
Received: from kroah.org ([198.145.64.141]:48773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab0JEWbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:31:41 -0400
Date: Tue, 5 Oct 2010 15:20:15 -0700
From: Greg KH <greg@kroah.com>
To: T Dent <tdent48227@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: [PATCH v3 12/20] Staging: rtl8192su: ieee80211: Makefile:
 cleaned up Makefile cflag lines
Message-ID: <20101005222015.GA28165@kroah.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
 <1286037489-28439-12-git-send-email-tdent48227@gmail.com>
 <20101005190209.GA3386@kroah.com>
 <AANLkTimY3iVfQgpNqJAVATFCMaQ1b=xyvyVKctyxMkFs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimY3iVfQgpNqJAVATFCMaQ1b=xyvyVKctyxMkFs@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 05:47:23PM -0400, T Dent wrote:
> On 10/5/10, Greg KH <greg@kroah.com> wrote:
> > On Sat, Oct 02, 2010 at 12:38:01PM -0400, Tracey Dent wrote:
> >> Changed to use the proper ccflags-y option
> >>
> >> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> >> ---
> >>  drivers/staging/rtl8192su/ieee80211/Makefile |   10 +++++-----
> >
> > This file is no longer in linux-next.
> 
> I Didn't know that. I guess because I did the patches based on the
> current linus tree.

You should always send patches against the linux-next tree, as it
contains the accumulated patches that will be sent to Linus next time
around.

> So you want me to resend it without this driver?

Nope, I got your other ones.

thanks,

greg k-h
