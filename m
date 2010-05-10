Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0EJXLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:11:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631Ab0EJXLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:11:06 -0400
Date: Mon, 10 May 2010 16:10:58 -0700
From: Greg KH <gregkh@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: Call console_verbose in panic
Message-ID: <20100510231058.GA19546@suse.de>
References: <20100510225959.GC12203@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510225959.GC12203@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 08:59:59AM +1000, Anton Blanchard wrote:
> 
> Most distros turn the console verbosity down and that means a backtrace after
> a panic never makes it to the console. I assume we haven't seen this because
> a panic is often preceeded by an oops which will have called console_verbose.
> There are however a lot of places we call panic directly, and they are
> broken.
> 
> Use console_verbose like we do in the oops path to ensure a directly called
> panic will print a backtrace.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Looks good to me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
