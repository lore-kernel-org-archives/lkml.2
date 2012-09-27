Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2I0UJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 16:09:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57577 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2I0UJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 16:09:26 -0400
Date: Thu, 27 Sep 2012 13:09:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3.5 0/2] seccomp and vsyscall fixes
Message-ID: <20120927200921.GA16868@kroah.com>
References: <cover.1342566495.git.luto@amacapital.net>
 <20120927173622.GB21025@kroah.com>
 <CALCETrUi5RrJoq9CS8mA31tiT9WPW4cc27zyjymAj5uqWqMptw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUi5RrJoq9CS8mA31tiT9WPW4cc27zyjymAj5uqWqMptw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 12:40:10PM -0700, Andy Lutomirski wrote:
> [cc James Morris]
> 
> This has been pending since the 3.6 merge window.  Patch 2/2 barely
> matters because it's almost impossible to detect its effect -- it's
> more about future proofing against new architectures.  Patch 1/2 has
> been slightly tweaked here:
> 
> http://lkml.kernel.org/r/%3C744e07394a02be3d3ef52c22ccedb24d9a478fe1.1343869850.git.luto@amacapital.net%3E
> 
> and will soon appear here (once the cache refreshes)
> 
> https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/seccomp-vsyscall/patch_v2
> 
> I can wait for someone to pick it up or I can send a pull request from
> my tree.  FWIW, the same patch applies cleanly to -next.

You might want to resend them, in patch form, to James, if he's missed
them already.

thanks,

greg k-h
