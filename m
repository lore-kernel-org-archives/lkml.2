Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3AGSYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:24:33 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37478 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3AGSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:24:31 -0500
Date: Mon, 7 Jan 2013 10:24:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] UIO changes for v3.8
Message-ID: <20130107182427.GA25493@kroah.com>
References: <20121213184038.GJ4261@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213184038.GJ4261@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 07:40:39PM +0100, Hans J. Koch wrote:
> Hi Greg,
> my new UIO tree is based on your current char-misc tree. Please pull the
> following two patches.
> 
> Thanks,
> Hans
> 
> The following changes since commit 1ebaf4f4e6912199f8a4e30ba3ab55da2b71bcdf:
> 
>   Merge branch 'x86-timers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-12-11 20:01:33 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://hansjkoch.de:/home/repos/git/char-misc.git uio-devel

$ git pull git://hansjkoch.de:/home/repos/git/char-misc.git uio-devel
fatal: Unable to look up hansjkoch.de (port <none>) (Servname not supported for ai_socktype)

Did you not use the proper host name here?

And this is a signed tag, right?  uio-devel doesn't seem like a very
good signed tag name :)

thanks,

greg k-h
