Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab2JXEPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 00:15:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57196 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2JXEPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 00:15:11 -0400
Date: Tue, 23 Oct 2012 21:15:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging/sbe-2t3e3: Use netdev_ printks in main.c
Message-ID: <20121024041543.GA29712@kroah.com>
References: <20121019191038.GA18369@kroah.com>
 <1351047928-7234-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351047928-7234-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:05:28PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warning.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>

I never got the 3/3 patch in this series :(

greg k-h
