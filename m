Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab0DHU3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:29:37 -0400
Received: from kroah.org ([198.145.64.141]:42731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546Ab0DHU2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:28:00 -0400
Date: Thu, 8 Apr 2010 13:20:30 -0700
From: Greg KH <greg@kroah.com>
To: Eli Lindsey <eli@siliconsprawl.com>
Cc: gregkh@suse.de, d@teklibre.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: frontier: fix extra spaces in tranzport.c
Message-ID: <20100408202030.GA10914@kroah.com>
References: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 12:15:30AM -0600, Eli Lindsey wrote:
> This is a patch to tranzport.c that removes two cases of unnecessary whitespace
> before a quoted newline found by the checkpatch.pl tool

This is already in the tree.

thanks,

greg k-h
