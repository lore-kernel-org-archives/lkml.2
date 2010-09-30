Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0I3Cia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:38:30 -0400
Received: from kroah.org ([198.145.64.141]:56571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0I3Ci3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:38:29 -0400
Date: Wed, 29 Sep 2010 19:31:50 -0700
From: Greg KH <greg@kroah.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Don't dereference snd->filp
Message-ID: <20100930023150.GC4035@kroah.com>
References: <4CA3CA3C.4080709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA3CA3C.4080709@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 01:22:36AM +0200, Roel Kluin wrote:
> Don't dereference snd->filp.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/usb/gadget/u_audio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Or should it return the error pointer?

Probably, what happens if you do?

thanks,

greg k-h
