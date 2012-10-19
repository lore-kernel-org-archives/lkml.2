Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab2JSTKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:10:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:52110 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab2JSTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:10:41 -0400
Date: Fri, 19 Oct 2012 12:10:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging/sbe-2t3e3: Use netdev_ printks in main.c
Message-ID: <20121019191038.GA18369@kroah.com>
References: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:57:51PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warning.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>

Your coding style cleanup patch introduced more coding style errors, not
good.  Please always remember to use checkpatch.pl on your patches you
create.

please fix up.

greg k-h
