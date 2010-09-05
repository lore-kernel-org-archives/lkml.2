Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab0IEGdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:33:54 -0400
Received: from kroah.org ([198.145.64.141]:45278 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab0IEGdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:33:54 -0400
Date: Sat, 4 Sep 2010 21:49:02 -0700
From: Greg KH <greg@kroah.com>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, apatard@mandriva.com,
        randy.dunlap@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: xgifb: fixed many style issues in XGI_accel.c
Message-ID: <20100905044902.GA3130@kroah.com>
References: <1283595045-6922-1-git-send-email-pshah.mumbai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283595045-6922-1-git-send-email-pshah.mumbai@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 03:40:45PM +0530, Prashant P. Shah wrote:
> This is a patch to the XGI_accel.c file that fixes many style
> issues found by the checkpatch.pl tool.
> - extra spaces
> - invalid code indent
> - extra braces
> - invalid comment style
> 
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>

Um, I think you forgot to build this patch, it dies a horrible death.

Please always test your patches before sending them out.

thanks,

greg k-h
