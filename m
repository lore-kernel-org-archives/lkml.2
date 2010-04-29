Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab0D3RZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:25:09 -0400
Received: from kroah.org ([198.145.64.141]:41277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758631Ab0D3RXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:23:34 -0400
Date: Thu, 29 Apr 2010 09:06:30 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35tx.c Coding style fixes.
Message-ID: <20100429160630.GA8710@kroah.com>
References: <1269764725-10190-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269764725-10190-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 10:25:25AM +0200, Lars Lindley wrote:
> I fixed the problems reported by checkpatch.pl except some long
> lines and printk:s.
> I also removed versioning comments.
> Builds fine, .o identical to before and checked it with
> Dan Carpenters strip_whitespace.pl and diff.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

This no longer applies on linux-next due to some upstream changes.  Can
you rediff it and resend it?

thanks,

greg k-h
