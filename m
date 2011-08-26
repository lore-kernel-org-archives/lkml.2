Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab1HZNbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:31:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab1HZNbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:31:10 -0400
Date: Fri, 26 Aug 2011 06:25:53 -0700
From: Greg KH <gregkh@suse.de>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH] Staging: comedi: fix printk warning issue in
 cb_pcidas64.c
Message-ID: <20110826132553.GA20037@suse.de>
References: <1314364132-3545-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314364132-3545-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 06:38:52PM +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the cb_pcidas64.c file that fixes up a printk warning found by the checkpatch.pl tool

Your line is way too long, please wrap it properly.

> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>

I need a full name (first/last) and emails that match each other (your
from and signed-off-by: do not).

Also, how many patches are in this series, just 1?  Please tell me how
many patches you are sending like the documentation says to.

You sent a second one as well, please redo that in this manner as well.

thanks,

greg k-h
