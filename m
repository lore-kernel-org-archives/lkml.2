Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0HRTwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:52:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab0HRTwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:52:17 -0400
Date: Wed, 18 Aug 2010 12:44:10 -0700
From: Greg KH <gregkh@suse.de>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/4] platform: Use drv->driver.bus instead of assuming
 platform_bus_type
Message-ID: <20100818194410.GA17421@suse.de>
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
 <1282158943-11902-2-git-send-email-ppannuto@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282158943-11902-2-git-send-email-ppannuto@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 12:15:40PM -0700, Patrick Pannuto wrote:
> In theory (although not *yet* in practice), a driver being passed
> to platform_driver_probe might have driver.bus set to something
> other than platform_bus_type. Locking drv->driver.bus is always
> correct.
> 
> Change-Id: Ib015c35237eb5493d17a812576a3a9906e1344d4

What is that field?  Why did you add it?

confused,

greg k-h
