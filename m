Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3ACWkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:40:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3ACWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:40:13 -0500
Date: Thu, 3 Jan 2013 14:40:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: [PATCH] platform: Fix platform device resource linking
Message-ID: <20130103224020.GB4571@kroah.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 12:31:10AM +0200, Pantelis Antoniou wrote:
> Platform device removal uncovered a number of problems with
> the way resources are handled in the core platform code.
> 
> Resources now form child/parent linkages and this requires
> proper linking of the resources. On top of that the OF core
> directly creates it's own platform devices. Simplify things
> by providing helper functions that manage the linking properly.
> 
> Two functions are provided:
> 
> platform_device_link_resources(), which links all the
> linkable resources (if not already linked).
> 
> and platform_device_unlink_resources(), which unlinks all the
> resources.

Who would call these functions, and why?

And why have we never seen problems with removing platform devices
previously?

thanks,

greg k-h
