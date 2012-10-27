Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab2J0QCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:02:34 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56552 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2J0QCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:02:32 -0400
Date: Sat, 27 Oct 2012 09:03:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: clouds.yan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] debugfs: pass NULL as the last parameter of
 debugfs_print_regs32()
Message-ID: <20121027160318.GA4572@kroah.com>
References: <20121027150715.GD3349@kroah.com>
 <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
 <20121027154549.GA7132@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121027154549.GA7132@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 05:45:49PM +0200, Alessandro Rubini wrote:
> >> This function is only used (twice) by the author of it, and the
> >> 'prefix' feature is never used.
> 
> I introduced it to shrink some internal code that had a lot of
> repetition in the debugfs files implementation. In that context I use
> the prefix string.  Some of the code had later been submitted, but not
> yet all of it.  Later work by Davide Ciminaghi moved our MFD user to
> the regmap interface, according to maintainer's suggestion (which
> however means loosing register names from the debugfs dump).

What is the status of the rest of that code getting accepted?

> > If the parameter isn't being used, please, just delete it.
> 
> It is not currently used by upstream callers, but the function itself
> uses it as documented (Documentation/...).  I wouldn't remove the
> feature and introduce an incompatibility just for this.

But if no one is using it, we can fix the documentation, and just drop
it.

thanks,

greg k-h
