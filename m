Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2FEGoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:44:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59560 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2FEGoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:44:22 -0400
Date: Mon, 4 Jun 2012 20:58:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: Fix the checkpatch warnings
Message-ID: <20120605035833.GA16700@kroah.com>
References: <1337520702-22961-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337520702-22961-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 07:01:42PM +0530, Devendra Naga wrote:
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/wlan-ng/cfg80211.c |   27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)


Ok, you sent me 5 patches, all with the same subject (except for 3 of
them you used x/3, which was nice, but you duplicated 3/3 for some
reason.)

I can't accept that, please be more specific in your subject: line.

Also, in the body, say exactly what checkpatch warnings you fixed, and,
if you fixed more than one type of warning, that might indicate that you
should break the patch up into different parts.

So, I've dropped all 5 patches you've sent me, please redo and resend.

thanks,

greg k-h
