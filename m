Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0EAQni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 12:43:38 -0400
Received: from kroah.org ([198.145.64.141]:38636 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0EAQne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 12:43:34 -0400
Date: Fri, 30 Apr 2010 14:53:28 -0700
From: Greg KH <greg@kroah.com>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, jochen.maes@sejo.be,
       pavel@ucw.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream: pmem: code style fixes
Message-ID: <20100430215328.GA12282@kroah.com>
References: <1272577054-4656-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272577054-4656-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 05:37:34PM -0400, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This patch include <linux/io.h> instead of <asm/io.h> and
> <linux/uaccess.h> instead of <asm/uaccess.h>.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  drivers/staging/dream/pmem.c |    4 ++--

This does not apply against the latest linux-next tree.  Care to rebase
it and try it again?

thanks,

greg k-h
