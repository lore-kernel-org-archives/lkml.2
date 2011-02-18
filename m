Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1BRVby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:31:54 -0500
Received: from kroah.org ([198.145.64.141]:41550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab1BRVbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:31:34 -0500
Date: Fri, 18 Feb 2011 13:26:54 -0800
From: Greg KH <greg@kroah.com>
To: Dustan Bower <dustan.bower@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, fmhess@users.sourceforge.net,
        abbotti@mev.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers.c: fixed braces coding style
 issue.
Message-ID: <20110218212654.GA18755@kroah.com>
References: <1298010728-7036-1-git-send-email-dustan.bower@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298010728-7036-1-git-send-email-dustan.bower@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 01:32:08AM -0500, Dustan Bower wrote:
> Fixed coding style issue.
> 
> Signed-off-by: Dustan Bower <dustan.bower@gmail.com>
> ---
>  drivers/staging/comedi/drivers.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

This patch doesn't apply to the linux-next tree, can you please redo it
against that one?

thanks,

greg k-h
