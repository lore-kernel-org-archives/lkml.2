Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab0DHU2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:28:32 -0400
Received: from kroah.org ([198.145.64.141]:42722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933536Ab0DHU17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:27:59 -0400
Date: Thu, 8 Apr 2010 13:19:56 -0700
From: Greg KH <greg@kroah.com>
To: John Church <j.church@ymail.com>
Cc: gregkh@suse.de, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
       bernhard@schiffner-limbach.de, davem@davemloft.net,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fix coding style issues in
 r8180_core.c
Message-ID: <20100408201956.GA10896@kroah.com>
References: <1268099027-29438-1-git-send-email-j.church@ymail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268099027-29438-1-git-send-email-j.church@ymail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 01:43:47AM +0000, John Church wrote:
> ---
>  drivers/staging/rtl8187se/r8180_core.c |   98 ++++++++++++++++----------------
>  1 files changed, 49 insertions(+), 49 deletions(-)

This causes a build error, did you test your change?

thanks,

greg k-h
