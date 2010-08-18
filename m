Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab0HRPns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:43:48 -0400
Received: from kroah.org ([198.145.64.141]:47905 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0HRPnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:43:47 -0400
Date: Wed, 18 Aug 2010 08:43:30 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH] firmware_class: fix typo in error path
Message-ID: <20100818154330.GA4000@kroah.com>
References: <1282144518.5249.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282144518.5249.2.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 05:15:18PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In the error path, _request_firmware sets
> firmware_p to NULL rather than *firmware_p,
> which leads to passing a freed firmware
> struct to drivers when the firmware file
> cannot be found. Fix this.
> 
> Broken by commit f8a4bd3456b988fc73b2c.

Nice catch, thanks.  I'll queue it up.

greg k-h
