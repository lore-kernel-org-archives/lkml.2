Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0IFG24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:28:56 -0400
Received: from kroah.org ([198.145.64.141]:56065 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0IFG2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:28:55 -0400
Date: Sun, 5 Sep 2010 23:29:40 -0700
From: Greg KH <greg@kroah.com>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: gregkh@suse.de, randy.dunlap@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, apatard@mandriva.com
Subject: Re: [PATCH] Staging: xgifb: fixed many style issues in
	XGI_main_26.c
Message-ID: <20100906062940.GA4746@kroah.com>
References: <1283676299-7398-1-git-send-email-pshah.mumbai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283676299-7398-1-git-send-email-pshah.mumbai@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 02:14:59PM +0530, Prashant P. Shah wrote:
> This is a patch to the XGI_main_26 file that fixes many style
> issues found by the checkpatch.pl tool.
> - extra spaces
> - invalid code indent
> - extra braces
> - invalid comment style
> 
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>

Due to another change in this driver yesterday, this patch no longer
applies :(

Can you respin it against the linux-next tree of today and resend it?

thanks,

greg k-h
