Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2KPRGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:06:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62646 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2KPRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:06:20 -0500
Date: Fri, 16 Nov 2012 09:06:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: mdd.h: fixes tons of coding
 style issues
Message-ID: <20121116170616.GB30626@kroah.com>
References: <1353084911-8908-1-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353084911-8908-1-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:55:11PM +0200, Johan Meiring wrote:
> This commit sorts out a ton of styling issues, including the use of
> C99 // comments, spaces before and after tabs, etc. I also took the
> time to align stuff a little more neatly using tabs. The file is
> nowhere near ready, but it's a start.
> 
> Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
> ---
>  drivers/staging/wlags49_h2/mdd.h | 1593 +++++++++++++++++++-------------------
>  1 file changed, 797 insertions(+), 796 deletions(-)

A patch this big is almost impossible to review, sorry.  Please break it
up into smaller pieces.

thanks,

greg k-h
