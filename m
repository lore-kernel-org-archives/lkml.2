Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab0KLTRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:17:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab0KLTRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:17:31 -0500
Date: Fri, 12 Nov 2010 10:40:01 -0800
From: Greg KH <gregkh@suse.de>
To: Andres Salomon <dilinger@queued.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: devel@driverdev.osuosl.org, cjb@laptop.org, jon.nettleton@gmail.com,
        dsd@laptop.org, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: [PATCH 3/4] cs5535: add some additional cs5535-specific GPIO
	functionality
Message-ID: <20101112184001.GA20492@suse.de>
References: <20100925190712.6aa5c2fc@debxo> <20101112090841.2c0e52cc@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112090841.2c0e52cc@queued.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 09:08:41AM -0800, Andres Salomon wrote:
> Hi,
> 
> Does anyone have any comments on this?  Greg, since there's no gpio
> maintainer, would you mind picking it up for 2.6.38 (along w/ the
> subsequent patch, which allows olpc_dcon to build)?

There's no gpio maintainer?  I thought Andrew was doing this for now, or
was Grant?

Grant, I thought you were taking gpio stuff now, right?

thanks,

greg k-h
