Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab2ENTJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:09:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2ENTJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:09:29 -0400
Date: Mon, 14 May 2012 12:09:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 1/1] memory: tegra{20,30}-mc: Use dev_err_ratelimited()
Message-ID: <20120514190925.GA4001@kroah.com>
References: <1336981680-15297-2-git-send-email-hdoyu@nvidia.com>
 <1336990031-15567-1-git-send-email-hdoyu@nvidia.com>
 <4FB14FDE.2080409@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB14FDE.2080409@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:33:02PM -0600, Stephen Warren wrote:
> On 05/14/2012 04:07 AM, Hiroshi DOYU wrote:
> > Introduce a new dev_*_ratelimited() instead of pr_*_ratelimited() for
> > better info to print.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> But note that this relies on the following patch or a variant of it:
> 
> http://patchwork.ozlabs.org/patch/158899/
> 
> which isn't anywhere yet.
> 
> (A variant of that patch was patch 1/2 the first time this patch was
> posted, but v2 of this patch was posted separately without mentioning
> the dependency)

It was part of this thread, which I don't think you were copied on for
some reason.  Anyway, I applied it earlier today, thanks.

greg k-h
