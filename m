Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab0LMSgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:36:19 -0500
Received: from kroah.org ([198.145.64.141]:43066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585Ab0LMSgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:36:17 -0500
Date: Mon, 13 Dec 2010 10:36:01 -0800
From: Greg KH <greg@kroah.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Staging: vme_bridge: mark
 vme_master_resource->kern_base as __iomem
Message-ID: <20101213183601.GB11745@kroah.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
 <1292246196-2332-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292246196-2332-2-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:16:30PM +0900, Namhyung Kim wrote:
> vme_master_resource->kern_base is mapped by ioremap_nocache()
> thus should be marked as __iomem.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

I need some acks from Martyn on this series (minus the broken 1/8 patch)
before I can apply them.  Martyn?

thanks,

greg k-h
