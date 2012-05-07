Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2EGANc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:13:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45458 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2EGANb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:13:31 -0400
Date: Mon, 7 May 2012 01:13:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
Message-ID: <20120507001327.GC22082@ZenIV.linux.org.uk>
References: <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
 <20120506.163243.1653904376439925642.davem@davemloft.net>
 <20120506233234.GA22082@ZenIV.linux.org.uk>
 <20120506.193814.2029338625165610372.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506.193814.2029338625165610372.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 07:38:14PM -0400, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Mon, 7 May 2012 00:32:34 +0100
> 
> > bit looks dubious.  What happens when 32bit task makes a 64bit syscall?
> > Do we really want to drop upper 32 bits of all arguments in the copy we
> > are building?
> 
> I basically never intended to support 32-bit tasks making 64-bit
> system calls except in extremely limited situations such as ptrace()
> so that a 32-bit gdb could debug 64-bit tasks.
> 
> Do we really have to support crap like this?

Hey, I'm all for getting rid of that...
