Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab0LTRWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:22:40 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45758 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab0LTRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GNC/YJz15pK++V5aGfX1ZT0h2tQW7eJ0fx7itk0xTMU13exrhyGgCfuQnWCu5OekZn
         CCRLTPJFF7BDYXzS9dAI2JHSzL8FotHPgylQk3cJ6z8BiYKfzIawhB7WlSkQ1/ZtAUhU
         Ykkdpdr9B7xo3H50m3bvD3O/lKS4eSR5w6COk=
Date: Mon, 20 Dec 2010 09:22:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Riku Voipio <riku.voipio@iki.fi>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] leds: leds-pca9532 cleanups
Message-ID: <20101220172228.GB9353@core.coreip.homeip.net>
References: <1292809777.15685.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292809777.15685.2.camel@mola>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 09:49:37AM +0800, Axel Lin wrote:
> This patch includes below fixes:
> 1. Remove unneeded input_free_device() after input_unregister_device().
> 2. Add pca9532_destroy_devices() function for destroy devices.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Changes for v2:
> Base on Dmitry's comments to add pca9532_destroy_devices() for destroy devices.
> 

Looks good, thank you for making changes.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
