Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161494Ab2JXW3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:29:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54255 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161317Ab2JXW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:29:39 -0400
Date: Wed, 24 Oct 2012 15:29:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anmol Sarma <unmole.in@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder: Fixed multi-line strings
Message-ID: <20121024222935.GB1891@kroah.com>
References: <n>
 <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
 <1349738114.15802.27.camel@joe-AO722>
 <20121022200212.GA18168@kroah.com>
 <20121023094335.GA13929@gmail.com>
 <20121024041335.GA25336@kroah.com>
 <20121024075840.GA4391@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024075840.GA4391@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:28:44PM +0530, Anmol Sarma wrote:
> >From abe5f2d4a7424c446f5e41cf57b4783eb9a04ab9 Mon Sep 17 00:00:00 2001
> From: Anmol Sarma <unmole.in@gmail.com>
> Date: Wed, 24 Oct 2012 12:57:35 +0530
> Subject: [PATCH] Staging: android: binder: Strings cleanup
> 
> Changed all user visible multi-line strings to single line.
> Removed 'binder:' prefix on stings.
> 
> Signed-off-by: Anmol Sarma <unmole.in@gmail.com>

Why did you get the subject wrong?

And why include the whole commit here, that forces me to edit the email.
Just use git-send-email to send the patch itself.

Try again?

thanks,

greg k-h
