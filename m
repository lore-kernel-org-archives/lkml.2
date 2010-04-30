Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0EAQnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 12:43:42 -0400
Received: from kroah.org ([198.145.64.141]:38639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab0EAQne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 12:43:34 -0400
Date: Fri, 30 Apr 2010 14:54:54 -0700
From: Greg KH <greg@kroah.com>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: arlan: fixed trailing whitespace style issue
	in arlan-main.c
Message-ID: <20100430215454.GA12371@kroah.com>
References: <1272644796-8068-1-git-send-email-pshah.mumbai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272644796-8068-1-git-send-email-pshah.mumbai@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 09:56:36PM +0530, Prashant P. Shah wrote:
> This is a patch to the arlan-main.c file that fixes up all the
> trailing whitespace errors found by the checkpatch.pl tool.
> 
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
> ---
>  drivers/staging/arlan/arlan-main.c |   82 ++++++++++++++++++------------------

This, and your other arlan patches, do not apply at all against the
latest linux-next tree for some reason.  Can you verify that they still
do apply as I sure can't seem to get them to.

thanks,

greg k-h
