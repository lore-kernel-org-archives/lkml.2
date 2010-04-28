Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0D1Ruh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:50:37 -0400
Received: from kroah.org ([198.145.64.141]:54619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab0D1RuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:50:07 -0400
Date: Wed, 28 Apr 2010 10:47:02 -0700
From: Greg KH <greg@kroah.com>
To: Steven Harms <sjharms@gmail.com>
Cc: gregkh@suse.de, d@teklibre.com, sharms@ubuntu.com, weiyi.huang@gmail.com,
       nm127@freemail.hu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: frontier: Remove unneeded spaces before
 newlines in alphatrack.c
Message-ID: <20100428174702.GA645@kroah.com>
References: <1268579060-7885-1-git-send-email-sharms@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268579060-7885-1-git-send-email-sharms@ubuntu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 11:04:20AM -0400, Steven Harms wrote:
> Removed unneeded spaces preceding newlines, as indicated by the checkpatch tool.
> Signed-off-by: Steven Harms <sharms@ubuntu.com>
> ---
>  drivers/staging/frontier/alphatrack.c |    6 +++---

Sorry, but someone already made these changes to the file before you did
:(

greg k-h
