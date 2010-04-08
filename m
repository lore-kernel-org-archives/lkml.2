Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab0DHUaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:30:07 -0400
Received: from kroah.org ([198.145.64.141]:42707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933494Ab0DHU1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:27:55 -0400
Date: Thu, 8 Apr 2010 13:10:43 -0700
From: Greg KH <greg@kroah.com>
To: Niadh <neilmunro@gmail.com>
Cc: gregkh@suse.de, bzolnier@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: rt2860: Removes all errors from wpa.h.
Message-ID: <20100408201043.GW31571@kroah.com>
References: <1267932694-3254-1-git-send-email-neilmunro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267932694-3254-1-git-send-email-neilmunro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 03:31:34AM +0000, Niadh wrote:
> This patch cleans up all errors but leaves all but four warnings, these are mostly typedefs and I don't know how to clean those up yet. The final warning is an 80 character limit warning, but I've yet to figure out how to clean that line up.
> 
> All were detected by the checkpatch.pl tool.

This patch caused a build error, did you test it out?

thanks,

greg k-h
