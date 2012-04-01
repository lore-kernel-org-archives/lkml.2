Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2DAVdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:33:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55463 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2DAVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:33:53 -0400
Date: Mon, 2 Apr 2012 00:33:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Valentin Nechayev <netch@netch.kiev.ua>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120401213347.GC4408@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
 <20120401182825.GJ21084@netch.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401182825.GJ21084@netch.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 09:28:26PM +0300, Valentin Nechayev wrote:
>  Sun, Apr 01, 2012 at 15:57:42, adobriyan wrote about "[PATCH] nextfd(2)": 
> 
> > So, don't add closefrom(2), add nextfd(2).
> > 
> > 	int nextfd(int fd)
> 
> Is it really needed here to create syscall? One shall update all arch
> lists for it. Instead, adding a new option for fcntl() (named e.g.
> F_NEXTFD) solves for all platforms simultaneously.

This is not a problem, build system even checks for not yet added syscalls.
Explicit syscall is better than multiplexer.
