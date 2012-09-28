Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2I1A0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:26:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:52772 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2I1A0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:26:45 -0400
Date: Thu, 27 Sep 2012 17:26:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: stable@vger.kernel.org, "Gortmaker, Paul" <Paul.Gortmaker@windriver.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.5 regression kernel oops in mount attempt without lockd
 present
Message-ID: <20120928002641.GR29949@kroah.com>
References: <505CBF46.1060901@windriver.com>
 <505DA444.7090805@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505DA444.7090805@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 06:43:00AM -0500, Jason Wessel wrote:
> 
> 
> Greg,
> 
> In 3.4.5, a regression was introduced from commit: ee92389156 "SUNRPC:
> move per-net operations from svc_destroy()".
> 
> This regression was actually fixed in a later upstream patch in
> v3.5-rc1, specifically 4db77695bf5 "LockD: pass service to per-net up
> and down functions", which means there is no stock kernel.org kernel
> that exhibits this particular crash.
> 
> Please add 4db77695bf5 to the 3.4.Y, it should cherry-pick cleanly.

Now queued up, thanks.

greg k-h
