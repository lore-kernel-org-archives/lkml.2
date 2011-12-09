Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1LIAFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:05:08 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:32780 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab1LIAFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:05:04 -0500
X-Sasl-enc: BgH4v7YS6gNWUs0dWMRllwOoL0ubutyFbWkUikX8W5QZ 1323389103
Date: Thu, 8 Dec 2011 16:03:11 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/30] Staging: comedi: fix brace coding style issue in
 ni_at_a2150.c
Message-ID: <20111209000311.GD31036@kroah.com>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323348745-31477-22-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323348745-31477-22-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 06:22:17PM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the ni_at_a2150.c file that fixes up a brace
> warning found by the checkpatch.pl tool.
> 
> Removed unnecessary printk statement.

Which causes a bug, please don't do that.

greg k-h
