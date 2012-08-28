Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2H1IDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 04:03:19 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:34325 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2H1IDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 04:03:13 -0400
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2012 04:03:11 EDT
Date: Tue, 28 Aug 2012 09:44:09 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        ben@decadent.org.uk, rob@landley.net, viro@zeniv.linux.org.uk,
        ludwig.nussel@suse.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH] debugfs: more tightly restrict default mount mode
Message-ID: <20120828074409.GA32750@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120827203215.GA16637@www.outflux.net>
References: <20120827203215.GA16637@www.outflux.net> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since the debugfs is mostly only used by root, make the default mount
> mode 0700. Most system owners do not need a more permissive value,
> but they can choose to weaken the restrictions via their fstab.

But if the default is strict, file-completion won't work and most
people will run a full root shell instead of sudo to save time. This
is a step back in my opinion.

Most administrators of their own machine won't go as far as changing
fstab (none of my students would, for example). On the other hand
admins of serious sites who are really concerned about doing "ls" over
debugfs will be able to customize.

So I vote against, knowing I'm late.

thanks
/alessandro
