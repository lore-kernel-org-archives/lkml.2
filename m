Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab2KOX0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:26:05 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45281 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2KOX0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:26:02 -0500
Date: Thu, 15 Nov 2012 15:25:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        alan@lxorguk.ukuu.org.uk, dan.carpenter@oracle.com
Subject: Re: [PATCH v3] staging: dgrp: dgrp_tty.c: return an -EFAULT if
 put_user() fails
Message-ID: <20121115232558.GA31883@kroah.com>
References: <1352981732-7864-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352981732-7864-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 05:45:32PM +0530, Kumar Amit Mehta wrote:
> Inspect the return value of put_user() and return -EFAULT on error.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>

This no longer applies to my tree, care to refresh and try again?

thanks,

greg k-h
