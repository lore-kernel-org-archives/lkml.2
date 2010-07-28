Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab0G1TCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:02:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:38000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0G1TCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:02:43 -0400
Date: Wed, 28 Jul 2010 11:56:54 -0700
From: Greg KH <gregkh@suse.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ernesto Ramos <ernesto@ti.com>, omar.ramirez@ti.com, ohad@wizery.com,
        ameya.palande@nokia.com, felipe.contreras@nokia.com,
        fernando.lugo@ti.com, linux-kernel@vger.kernel.org, nm@ti.com,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 5/5] staging:ti dspbridge: replace simple_strtoul by
 strict_strtoul
Message-ID: <20100728185654.GA7424@suse.de>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
 <1280328052-31292-2-git-send-email-ernesto@ti.com>
 <1280328052-31292-3-git-send-email-ernesto@ti.com>
 <1280328052-31292-4-git-send-email-ernesto@ti.com>
 <1280328052-31292-5-git-send-email-ernesto@ti.com>
 <1280328052-31292-6-git-send-email-ernesto@ti.com>
 <20100728150934.GA25299@suse.de>
 <AANLkTimNAoy7fJLeGeUPz2tZT9evUwD58tm7mOxTqqv2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimNAoy7fJLeGeUPz2tZT9evUwD58tm7mOxTqqv2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 09:40:19PM +0300, Andy Shevchenko wrote:
> On Wed, Jul 28, 2010 at 6:09 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Jul 28, 2010 at 09:40:52AM -0500, Ernesto Ramos wrote:
> >> Replace simple_strtoul by strict_strtoul in atoi function.
> >
> > Why not use the built-in kernel function instead of having your own atoi
> > function?
> The commit message left opened questions about
> http://dev.omapzoom.org/?p=tidspbridge/kernel-dspbridge.git;a=commit;h=b8af1123b47741086ef5a307ad1ec8fec6fc7f0d

Ok, but you will have to fix this up eventually, you need to use the
in-kernel library functions, or fix the in-kernel ones to add the
support you need.

thanks,

greg k-h
