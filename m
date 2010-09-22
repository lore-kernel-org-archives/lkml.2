Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0IVPGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:06:39 -0400
Received: from kroah.org ([198.145.64.141]:41791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0IVPGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:06:38 -0400
Date: Wed, 22 Sep 2010 08:06:03 -0700
From: Greg KH <greg@kroah.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Jon Smirl <jonsmirl@gmail.com>
Subject: Re: [PATCH v2 2/2] Doc/ABI: sysfs-drm initial document; "polled"
 entry
Message-ID: <20100922150603.GB26401@kroah.com>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
 <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
 <1285023750.30856.99.camel@morgan.silverblock.net>
 <1285125622.2518.21.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285125622.2518.21.camel@morgan.silverblock.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 11:20:22PM -0400, Andy Walls wrote:
> +Where:		/sys/devices/<...>/drm/cardN/cardN-C-M/polled
> +		For N a decimal system graphics adapter number: 0, 1, 2, ...
> +		For C a connector type name (including spaces) from the set:

Spaces?  Really?  Yeah, I know it will work just fine, but why go out of
your way to make it hard for people?

> +			Unknown
> +			VGA
> +			DVI-I
> +			DVI-D
> +			DVI-A
> +			Composite
> +			SVIDEO
> +			LVDS
> +			Component
> +			9-pin DIN
> +			DisplayPort
> +			HDMI Type A
> +			HDMI Type B
> +			TV
> +			Embedded DisplayPort

You could always just use a '_' instead of a space for those that need
it.

thanks,

greg k-h
