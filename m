Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1H2OYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:24:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1H2OXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:23:46 -0400
Date: Mon, 29 Aug 2011 07:23:29 -0700
From: Greg KH <gregkh@suse.de>
To: Ravishankarkm <ravi.shankar@greenturtles.in>
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: comedi: fix printk issue in cb_pcidda.c
Message-ID: <20110829142329.GA11205@suse.de>
References: <1314625813-13975-1-git-send-email-ravi.snkar@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314625813-13975-1-git-send-email-ravi.snkar@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 07:20:13PM +0530, Ravishankarkm wrote:
> From: Ravishankarkm <ravi.shankar@greenturtles.in>
> 
> This is a patch to the cb_pcidda.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankarkm <ravi.shankar@greenturtles.in>

Everything I mentioned in my last review has not been changed here, so
again, I'm going to drop all of your patches.

Please fix them up properly, and resend them, so I can apply them if you
want me to.  Otherwise this is pretty pointless, right?

greg k-h
