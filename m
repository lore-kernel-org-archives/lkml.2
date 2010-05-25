Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab0EYSGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:06:35 -0400
Received: from kroah.org ([198.145.64.141]:58074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758856Ab0EYSGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:06:34 -0400
Date: Tue, 25 May 2010 11:06:26 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: remove all code dependent on
 LINUX_VERSION_CODE
Message-ID: <20100525180625.GA10561@kroah.com>
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 12:01:33PM +0200, Jiri Kosina wrote:
> Remove all code which is dead for in-kernel driver due to being
> ifdefed by LINUX_VERSION_CODE.
> 
> While at it, also remove surrounding code which is commented out,
> or '#if 1' nops.

Can you break this out on a per-driver basis so that I can review it and
merge it easier?

thanks,

greg k-h
