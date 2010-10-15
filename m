Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0JOVRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:17:53 -0400
Received: from kroah.org ([198.145.64.141]:48114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab0JOVRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:17:52 -0400
Date: Fri, 15 Oct 2010 14:12:53 -0700
From: Greg KH <greg@kroah.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] staging: ft1000: Remove FT1000_INFO typedef usage.
Message-ID: <20101015211253.GA17875@kroah.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
 <1287144784-3359-7-git-send-email-marek.belisko@gmail.com>
 <20101015194040.GA20880@kroah.com>
 <AANLkTinWzONzzAd-nSzX1QeiVDS-c91sn44Biz2gtt_i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinWzONzzAd-nSzX1QeiVDS-c91sn44Biz2gtt_i@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:16:06PM +0200, Belisko Marek wrote:
> On Fri, Oct 15, 2010 at 9:40 PM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Oct 15, 2010 at 02:13:04PM +0200, Marek Belisko wrote:
> >> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> >> ---
> >>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   28 +++++++-------
> >>  .../staging/ft1000/ft1000-usb/ft1000_download.c    |   16 ++++----
> >>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   42 ++++++++++----------
> >>  drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |   14 +++---
> >>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    8 ++--
> >>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    6 +-
> >>  6 files changed, 57 insertions(+), 57 deletions(-)
> >
> > Something's wrong with this patch.  There was also something wrong with
> > one of the previous ones as well, but I fixed it up by hand.  It seems
> > that you forgot to send one of the patches in this series, which caused
> > this one to throw a lot of rejects.
> >
> > Care to resync on my tree to see what I haven't applied from you and
> > resend this one, and anything else I've missed?
> I forgot to send 1 patch if I check my git logs. I already send it
> ([PATCH] staging:ft1000: Remove dead code from ft1000_hw.c).
> 
> Hopefully it resolved all problems with patch applying.

No, that one doesn't apply either :(

Care to retry?

thanks,

greg k-h
