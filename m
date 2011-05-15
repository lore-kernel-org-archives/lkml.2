Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1EOEUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 00:20:43 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35357 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1EOEUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 00:20:42 -0400
X-Greylist: delayed 1882 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 May 2011 00:20:41 EDT
X-Originating-Ip: 216.16.235.2
Date: Sat, 14 May 2011 23:46:08 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: matt mooney <mfmooney@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] staging: usbip: add userspace code
Message-ID: <20110515034608.GA8484@foursquare.net>
References: <cover.1305369175.git.mfm@muteddisk.com> <7dce7775af890105a685b67408f38fbef99cbdfe.1305369176.git.mfm@muteddisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dce7775af890105a685b67408f38fbef99cbdfe.1305369176.git.mfm@muteddisk.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 03:55:07AM -0700, matt mooney wrote:
> +0fca  Research In Motion, Ltd.
> +	0001  Blackberry Handheld

For Barry, we recognize the following product ID's under the RIM Vendor ID:

	0001	The original ID, sometimes we call it Classic
	0004	The old Pearl dual-endpoint mode.  Had both Mass Storage
		and Database endpoints
	0006	Pearl in database-only endpoint mode
	8001	The 8200 series Pearl Flip
	8004	The 8120 Pearl (and some other new models I think)
	8007	The Storm

- Chris

