Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0GZWkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:40:19 -0400
Received: from kroah.org ([198.145.64.141]:39257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0GZWkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:40:17 -0400
Date: Mon, 26 Jul 2010 15:34:40 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        gregkh@suse.de, ss@aao.gov.au, joe@perches.com
Subject: Re: [PATCH v2] Staging: dt3155: make local variables static
Message-ID: <20100726223440.GA16147@kroah.com>
References: <201007231303.34672.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007231303.34672.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 01:03:34PM -0700, H Hartley Sweeten wrote:
> The symbols dt3155_dev_open, unique_tag, and allocatorAddr are only used in
> the file dt3155_drv.c and should be static. Also, as pointed out by Joe Perches,
> static variables do not need initialization so remove them. While here, also
> move the definition for allocatorAddr so that all the variables are declared at
> one place in the code.

This doesn't apply after applying your previous patch to this file :(

thanks,

greg k-h
