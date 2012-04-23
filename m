Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2DWVdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:33:40 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62477 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2DWVdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:33:39 -0400
Date: Mon, 23 Apr 2012 14:33:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: driverdevel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missed Cc for stable
Message-ID: <20120423213335.GA3603@kroah.com>
References: <4F92F910.60900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F92F910.60900@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 01:14:40PM -0500, Larry Finger wrote:
> Greg,
> 
> I missed a Cc for stable in this patch:
> 
> ================================================
> commit 2080913e017ab9f88379d93fd09546ad95faf87b
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Sat Feb 25 18:10:21 2012 -0600
> 
>     staging: r8712u: Fix regression caused by commit 8c213fa
> 
>     In commit 8c213fa "staging: r8712u: Use asynchronous firmware loading",
>     the command to release the firmware was placed in the wrong routine.
> 
>     In combination with the bug introduced in commit a5ee652 "staging: r8712u:
>     Interface-state not fully tracked", the driver attempts to upload firmware
>     that had already been released. This bug is the source of one of the
>     problems in https://bugs.archlinux.org/task/27996#comment89833.
> 
>     Tested-by: Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>
>     Tested-by: Adrian <agib@gmx.de>
>     Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ==============================================

Now applied to the 3.3-stable tree.

thanks,

greg k-h
