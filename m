Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2IZVK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:10:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2IZVKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:10:25 -0400
Date: Wed, 26 Sep 2012 14:10:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matt Porter <mporter@ti.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] uio: uio_pruss: port to AM33xx
Message-ID: <20120926211019.GB16674@kroah.com>
References: <1348667071-12631-1-git-send-email-mporter@ti.com>
 <1348667071-12631-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348667071-12631-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 09:44:29AM -0400, Matt Porter wrote:
> Add ifdefery hacks to only use SRAM on Davinci. This
> needs to be cleaned up with a sane generic SRAM allocator
> (like the DT based driver available that can't be used on
> Davinci which is just starting DT conversion) before it
> can go upstream.
> 
> Adds DT, pinctrl, and runtime PM support for use on
> AM33xx.

Ick, that's really messy, no other way to do this in a "cleaner"
fashion?

greg k-h
