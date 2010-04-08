Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab0DHU2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:28:39 -0400
Received: from kroah.org ([198.145.64.141]:42735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552Ab0DHU2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:28:01 -0400
Date: Thu, 8 Apr 2010 13:21:04 -0700
From: Greg KH <greg@kroah.com>
To: Eli Lindsey <eli@siliconsprawl.com>
Cc: gregkh@suse.de, d@teklibre.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: frontier: fix extra spaces in alphatrack.c
Message-ID: <20100408202103.GA10941@kroah.com>
References: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
 <1268115333-7971-2-git-send-email-eli@siliconsprawl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268115333-7971-2-git-send-email-eli@siliconsprawl.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 12:15:31AM -0600, Eli Lindsey wrote:
> This is a patch to alphatrack.c that removes three cases of unnecessary
> whitespace before a quoted newline found by the checkpatch.pl tool

This is already in the tree.

thanks,

greg k-h
