Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab0LWDfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 22:35:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:42570 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0LWDew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 22:34:52 -0500
Date: Wed, 22 Dec 2010 19:34:54 -0800
From: Greg KH <gregkh@suse.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v7 01/12] media: Media device node support
Message-ID: <20101223033454.GC14692@suse.de>
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1292844995-7900-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292844995-7900-2-git-send-email-laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 12:36:24PM +0100, Laurent Pinchart wrote:
> +/*
> + * Flag to mark the media_devnode struct as registered. Drivers must not touch
> + * this flag directly, it will be set and cleared by media_devnode_register and
> + * media_devnode_unregister.
> + */
> +#define MEDIA_FLAG_REGISTERED	0

It's a define, not a flag, or anything that any driver could touch.

And if you don't want anyone to touch the thing, then make it private
and unable to be touched by anyone else.  Otherwise it will be
touched...

thanks,

greg k-h
