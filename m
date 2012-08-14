Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2HNCCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:02:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53301 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2HNCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:02:46 -0400
Date: Mon, 13 Aug 2012 19:02:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: swetland@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Android: Small documentation changes and a bug fix
Message-ID: <20120814020242.GC26758@kroah.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:54:15PM +1000, Cruz Julian Bishop wrote:
> Hi,
> 
> This set of patches completes more documentation in android/logger.c, as well as fixing a bug there and a comment formatting issue in android/ashmem.c.
> 
> Sorry if kernel-doc was not supposed to be applied to driver files - If it isn't, I'll be sure to remember that for next time. :)
> 
> Cruz Julian Bishop (5):
>   Fix comment/license formatting in android/ashmem.c
>   Complete documentation of logger_entry in android/logger.h
>   Finish documentation of two structs in android/logger.c
>   Redocument some functions in android/logger.c
>   Fixes a potential bug in android/logger.c

In the future, please use a better subject line.  Something like:
	staging: android: logger: fix finish documentation of structure foo

As it is, I had to go and edit your subjects, and wrap your changelog
comments (72 columns please).  In the future, I might not.

thanks,

greg k-h
