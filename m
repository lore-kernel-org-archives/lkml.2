Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1CBPdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:33:10 -0500
Received: from kroah.org ([198.145.64.141]:57597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1CBPdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:33:08 -0500
Date: Wed, 2 Mar 2011 10:31:32 -0500
From: Greg KH <greg@kroah.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [RFC PATCH] staging: xgifb: remove private ioctls
Message-ID: <20110302153132.GA7325@kroah.com>
References: <1299016212-1060-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299016212-1060-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 11:50:12PM +0200, Aaro Koskinen wrote:
> Drop the badly defined and broken private ioctl interface. Since the
> driver is in staging, and some of the ioctls are clearly unsafe or not
> even working, it's unlikely that there are any users.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Is this just a RFC, or do you want me to apply this patch?

thanks,

greg k-h
