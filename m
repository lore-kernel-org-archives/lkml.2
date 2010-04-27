Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab0D0V5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:57:49 -0400
Received: from kroah.org ([198.145.64.141]:59032 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab0D0V5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:57:48 -0400
Date: Tue, 27 Apr 2010 14:39:44 -0700
From: Greg KH <greg@kroah.com>
To: Steven Harms <sjharms@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, hjanssen@microsoft.com,
       haiyangz@microsoft.com, npalix@diku.dk, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, sharms@ubuntu.com
Subject: Re: [PATCH] STAGING: hv: Update blkvsc_drive.c to remove spaces
 before newlines
Message-ID: <20100427213944.GA9517@kroah.com>
References: <1268514073-29212-1-git-send-email-sharms@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268514073-29212-1-git-send-email-sharms@ubuntu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 04:01:12PM -0500, Steven Harms wrote:
> Remove warnings for newlines with spaces before them, as indicated by the checkpatch.pl tool.
> Signed-off-by: Steven Harms <sharms@ubuntu.com>

Sorry, someone else already sent in this patch before you :(

greg k-h
