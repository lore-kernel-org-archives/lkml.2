Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2H1PCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:02:52 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47422 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab2H1PC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:02:28 -0400
Date: Tue, 28 Aug 2012 11:02:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Subject: Re: Hardening debugfs (Was Re: [PATCH] debugfs: more tightly
 restrict default mount mode)
Message-ID: <20120828150215.GB23035@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ben Hutchings <ben@decadent.org.uk>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
	Ludwig Nussel <ludwig.nussel@suse.de>,
	Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
References: <20120827203215.GA16637@www.outflux.net>
 <20120828144110.GA23035@thunk.org>
 <1346165758.15747.7.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346165758.15747.7.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 07:55:58AM -0700, Ben Hutchings wrote:
> 
> The problems are apparently larger than specific modules:
> http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-July/000894.html
> 

Sure, but most of those problems require root access, or physical
access to the hardware.  And a number of the "can oops the kernel"
assume module disappears out from under the open file descriptor, so
(a) that's a problem that can be fixed, and (b) if we can suppress a
random device driver from having its debugfs directory appear by
default, it certainly helps things.

					- Ted
