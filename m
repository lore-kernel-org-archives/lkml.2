Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0D1XIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:08:50 -0400
Received: from kroah.org ([198.145.64.141]:51649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab0D1XIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:08:17 -0400
Date: Wed, 28 Apr 2010 15:51:29 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, pavel@ucw.cz, diegoliz@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds.c: converted long if-else to
 switch
Message-ID: <20100428225129.GD24604@kroah.com>
References: <1268779048-21397-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268779048-21397-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 11:37:28PM +0100, Lars Lindley wrote:
> I converted the long if-else in function Mds_HeaderCopy() to a switch
> instead. It compiles fine but i don't have the hardware to test.
> Please check that I didn't do anything bad to it..
> The patch applies on top of this patch:
> Message-Id: <1268670973-6223-1-git-send-email-lindley@coyote.org>
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

This doesn't apply on top of linux-next, care to respin it?

thanks,

greg k-h
