Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab0LMSgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:36:08 -0500
Received: from kroah.org ([198.145.64.141]:43035 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab0LMSgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:36:07 -0500
Date: Mon, 13 Dec 2010 10:26:56 -0800
From: Greg KH <greg@kroah.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: vme_ca91cx42: use __dev{init,exit} for
 ->probe/remove
Message-ID: <20101213182656.GA4645@kroah.com>
References: <1292141068-31458-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292141068-31458-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:04:27PM +0900, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |   12 +++++++-----

This patch does not apply to the linux-next tree, what did you generate
it against?

Also, why are you marking these functions, is it really needed?  Same
thing for your 2/2 patch.

thanks,

greg k-h
