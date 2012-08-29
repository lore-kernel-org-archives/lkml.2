Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103Ab2H2EJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 00:09:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40519 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2H2EJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 00:09:39 -0400
Date: Tue, 28 Aug 2012 21:09:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rob Landley <rob@landley.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Subject: Re: Hardening debugfs (Was Re: [PATCH] debugfs: more tightly
 restrict default mount mode)
Message-ID: <20120829040935.GB21265@kroah.com>
References: <20120827203215.GA16637@www.outflux.net>
 <20120828144110.GA23035@thunk.org>
 <503D4C71.9040501@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503D4C71.9040501@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 05:55:45PM -0500, Rob Landley wrote:
> I've always been a bit confused by the debugfs design, which seems a
> giant compost heap like /proc where we find a specific styrofoam cup
> useful and the temporary thing becomes permanent. (Why is there _one_
> debugfs?)

The rules for debugfs are very simple:
	There are no rules.

That's it.  It's up to the kernel developer to do what they need to do,
for debugging stuff, how ever they best see fit.

Yes, it replaces proc for all of the debugging stuff that shouldn't have
been there before, how it's structured, is up to the developer adding
the code.

greg k-h
