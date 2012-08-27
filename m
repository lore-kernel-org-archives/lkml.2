Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2H0Uld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:41:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2H0Ulc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:41:32 -0400
Date: Mon, 27 Aug 2012 13:41:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] debugfs: more tightly restrict default mount mode
Message-ID: <20120827204127.GA19544@kroah.com>
References: <20120827203215.GA16637@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827203215.GA16637@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 01:32:15PM -0700, Kees Cook wrote:
> Since the debugfs is mostly only used by root, make the default mount
> mode 0700. Most system owners do not need a more permissive value,
> but they can choose to weaken the restrictions via their fstab.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Ok, you've worn me down, let's see how well this works, I'll queue this
up for 3.7.

greg k-h
