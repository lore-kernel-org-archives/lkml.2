Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2CHSAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:00:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53868 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849Ab2CHSAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:00:50 -0500
X-Sasl-enc: Mis8pAenBvh4fY9sKu8fEWlcddvODNU9p5fJNWW1Oe7a 1331229649
Date: Thu, 8 Mar 2012 10:00:48 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20120308180048.GC26516@kroah.com>
References: <20120308152110.12c805f59c45251d79bcb24b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308152110.12c805f59c45251d79bcb24b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 03:21:10PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/staging/sep/sep_driver.c:55:32: fatal error: linux/rar_register.h: No such file or directory
> 
> Caused by commit 33e9970add94 ("x86/mid: Kill off Moorestown").
> 
> Following previous instructions, I have disabled the staging tree driver
> using this patch (pending a fix in the tip tree):

Looks good to me.  Alan, care to send me an update that fixes this
driver for real?

thanks,

greg k-h
