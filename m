Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab0D3RDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:03:51 -0400
Received: from kroah.org ([198.145.64.141]:49560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab0D3RDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:03:44 -0400
Date: Thu, 29 Apr 2010 12:13:28 -0700
From: Greg KH <greg@kroah.com>
To: John D Sheehan <john.d.sheehan@gmail.com>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: winbond: checkpatch.pl tool fixes
Message-ID: <20100429191328.GG21799@kroah.com>
References: <1272544722-5908-1-git-send-email-john.d.sheehan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272544722-5908-1-git-send-email-john.d.sheehan@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 01:38:42PM +0100, John D Sheehan wrote:
> From: John Sheehan <john.d.sheehan@gmail.com>
> 
> fix whitespace issues
> replace C99 comments
> add KERN_INFO to printk
> 
> Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
> ---
>  drivers/staging/winbond/wbusb.c |  302 ++++++++++++++++++++++-----------------

Sorry, someone else already made these changes :(

greg k-h
