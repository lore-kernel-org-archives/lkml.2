Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2JNL1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 07:27:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50382 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2JNL06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 07:26:58 -0400
Date: Sun, 14 Oct 2012 04:26:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: Staging: CSR: made corrections on the
 indentation errors
Message-ID: <20121014112652.GA542@kroah.com>
References: <n>
 <1350213611-19806-1-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350213611-19806-1-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 08:20:11PM +0900, Sangho Yi wrote:
> Originally there were a lot mis-indentation, so I made changes to use
> only the tabs (no spaces) on indenting code.
> - Still, the typedef struct ... tells warning message on checkpatch.pl.

Yes, we shouldn't be using a typedef, but why did you change the typedef
itself:

> -typedef struct
> -{
> -    u32 sec;
> -    u16 msec;
> +typedef struct _CsrTimeUtc {
> +	u32 sec;
> +	u16 msec;
>  } CsrTimeUtc;

Why add the _CsrTimeUtc here?  That's not really needed, right?

thanks,

greg k-h
