Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0FNTjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:39:09 -0400
Received: from kroah.org ([198.145.64.141]:43736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab0FNTjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:08 -0400
Date: Mon, 14 Jun 2010 12:35:54 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on
 Linux-2.6.xx
Message-ID: <20100614193554.GB19411@kroah.com>
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
 <20100614162002.GA13902@kroah.com>
 <AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 02:44:36AM +0800, Jeff Chua wrote:
> On Tue, Jun 15, 2010 at 12:20 AM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Jun 14, 2010 at 11:16:29PM +0800, Jeff Chua wrote:
> 
> 
> > This is a warning that you can ignore, it's been fixed in the latest
> > tree (2.6.35-rc3).
> >
> > try that and see.
> 
> Greg,
> 
> Ok, just tried rc3 and it's fixed the 1st OOPS.

Note, it was not an oops, just a warning, and would not cause any
problems.

> But I'm still seeing the "ataX" incrementing from ata7 to ata8, ata9
> ... after taking out and putting back the card. It seems the interface
> is still not shutting down properly. ... Any command to shutdown it
> down gracefully?

I don't know, maybe the libata developers can help you out here.

good luck,

greg k-h
