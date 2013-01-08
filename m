Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3AHWKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:10:12 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:37953 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3AHWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:10:10 -0500
Date: Tue, 8 Jan 2013 14:10:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [add to stable] ftrace: Do not function trace inlined functions
Message-ID: <20130108221006.GA29782@kroah.com>
References: <1357681121.5190.42.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357681121.5190.42.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 04:38:41PM -0500, Steven Rostedt wrote:
> Hi Greg and Ben,
> 
> Can you add commit 45959ee7aa645815a5ce303a0ea1e48a21e67c6a to the
> stable trees.

That showed up in 3.3-rc1, so I don't think it's needed in 3.2-stable.

But why add it now?  What does it "fix" for 3.4 and 3.7?

thanks,

greg k-h
