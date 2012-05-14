Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2ENPvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:51:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35842 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2ENPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:51:50 -0400
Date: Mon, 14 May 2012 08:51:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] USB: serial: Changes to conform with checkpatch. -
 space before tabs
Message-ID: <20120514155146.GA30390@kroah.com>
References: <1336916225-26591-1-git-send-email-puzzleduck@gmail.com>
 <1336916225-26591-2-git-send-email-puzzleduck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336916225-26591-2-git-send-email-puzzleduck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 11:37:00PM +1000, Ben Minerds wrote:
> Removed 53 checkpatch.sh warnings.
> 
> Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
> ---
>  drivers/usb/serial/keyspan.c |  106 +++++++++++++++++++++---------------------
>  1 files changed, 53 insertions(+), 53 deletions(-)

What tree did you create this patch series against?  I get a ton of fuzz
and rejects against the usb-next branch, which is what it should be
created against.

Care to refresh this patch series against that tree so I can actually
apply it?

thanks,

greg k-h
