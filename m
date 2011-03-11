Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1CKWd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:33:27 -0500
Received: from kroah.org ([198.145.64.141]:49634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab1CKWdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:33:24 -0500
Date: Fri, 11 Mar 2011 14:29:55 -0800
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: Re: [PATCH next 1/6] staging: altera-stapl: fix memory leaks
Message-ID: <20110311222955.GA28689@kroah.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 05:43:03AM +0300, Alexander Beregalov wrote:
> Free resources before exit.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> Cc: Igor M. Liplianin <liplianin@netup.ru>
> ---
>  drivers/staging/altera-stapl/altera.c |    9 +++++++--

This isn't in my tree, it needs to go through Mauro's tree.

thanks,

greg k-h
