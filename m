Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1LIAF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:05:29 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58103 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1LIAFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:05:06 -0500
X-Sasl-enc: oh6LCvQK3oFuV0tGd0e5WZbvwgyn3XqAJ+n6mHG7pq6x 1323389106
Date: Thu, 8 Dec 2011 16:03:55 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/30] Staging: comedi: fix brace coding style issue in
 ni_at_a2150.c
Message-ID: <20111209000355.GF31036@kroah.com>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323348745-31477-23-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323348745-31477-23-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 06:22:18PM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the ni_at_a2150.c file that fixes up a brace
> warning found by the checkpatch.pl tool.

No it doesn't.

