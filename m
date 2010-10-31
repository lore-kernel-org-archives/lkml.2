Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0JaOXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 10:23:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab0JaOXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 10:23:09 -0400
Date: Sun, 31 Oct 2010 07:13:17 -0700
From: Greg KH <gregkh@suse.de>
To: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: use after free in serport
Message-ID: <20101031141317.GA25243@suse.de>
References: <20101030111618.GA29915@Chamillionaire.breakpoint.cc> <4CCD33E6.7000104@suse.cz> <20101031104136.GA511@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101031104136.GA511@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 11:41:36AM +0100, Sebastian Andrzej Siewior wrote:
> * Jiri Slaby | 2010-10-31 10:16:22 [+0100]:
> 
> >I think so:
> >http://lkml.org/lkml/2010/10/21/223
> >
> >(the updated patch attached)
> 
> Thank you very much the patch, it fixes my problem. The commit that is
> causing the bug (65b770468e98, ("tty-ldisc: turn ldisc user count into a
> proper refcount")) was merged v2.6.31-rc6~66^2~1. Any chance that you
> push it stable once it hits mainline?

Yes, I will do so.

thanks,

greg k-h
