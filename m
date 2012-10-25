Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598Ab2JYTZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:25:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42638 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965017Ab2JYTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:25:14 -0400
Date: Thu, 25 Oct 2012 12:25:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anmol Sarma <unmole.in@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder: Fixed multi-line strings
Message-ID: <20121025192510.GA26600@kroah.com>
References: <20121024222935.GB1891@kroah.com>
 <1351152407-5666-1-git-send-email-unmole.in@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351152407-5666-1-git-send-email-unmole.in@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:36:47PM +0530, Anmol Sarma wrote:
> Changed all user visible multi-line strings to single line.
> Removed 'binder:' prefix on stings.
> 
> Signed-off-by: Anmol Sarma <unmole.in@gmail.com>
> ---
>  drivers/staging/android/binder.c |  358 +++++++++++++++-----------------------
>  1 file changed, 143 insertions(+), 215 deletions(-)

Better, thanks.  But it doesn't apply against my tree, can you please
redo it against the linux-next release and resend it?

thanks,

greg k-h
