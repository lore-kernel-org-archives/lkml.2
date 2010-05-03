Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0ECTMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:12:34 -0400
Received: from kroah.org ([198.145.64.141]:49370 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab0ECTLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:11:40 -0400
Date: Mon, 3 May 2010 12:02:57 -0700
From: Greg KH <greg@kroah.com>
To: Mark Rankilor <reodge@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, john.d.sheehan@gmail.com,
       mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: comedi: Moved some EXPORT_SYMBOL() macros
Message-ID: <20100503190257.GA27407@kroah.com>
References: <1272879549-26711-1-git-send-email-reodge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272879549-26711-1-git-send-email-reodge@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 05:39:09PM +0800, Mark Rankilor wrote:
> This is a patch to range.c that rearranges some EXPORT_SYMBOL() macros to please
> checkpatch.pl
> 
> Signed-off-by: Mark Rankilor <reodge@gmail.com>

Heh, I didn't make this change, as I thought it was "ugly", but it makes
sense to apply this patch to keep the tool quiet :)

thanks,

greg k-h
