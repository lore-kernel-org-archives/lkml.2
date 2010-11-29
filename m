Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0K2H7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 02:59:35 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:42959 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab0K2H7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 02:59:34 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKvq8kxR8I07/2dsb2JhbACifHLBKg2FOgSPdQ
Date: Mon, 29 Nov 2010 08:59:31 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rdc321x-gpio: fix null pointer dereference while
	accessing platform_data
Message-ID: <20101129075931.GF4046@infomag.iguana.be>
References: <201011261039.54817.florian@openwrt.org> <20101126121546.GM5520@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126121546.GM5520@sortiz-mobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel, Florian,

You also have my ACK for the watchdog driver.

Kind regards,
Wim.

> Hi Florian,
> 
> On Fri, Nov 26, 2010 at 10:39:54AM +0100, Florian Fainelli wrote:
> > rdc321x-gpio currently fetches its driver specific data by using the platform_
> > device->platform_data pointer, this is wrong because the mfd device which
> > registers our platform_device has been added using mfd_add_device() which sets
> > the platform_device->driver_data pointer instead.
> > 
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> > CC: stable@kernel.org
> I'll take those 2 patches.
> 
> Cheers,
> Samuel.
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/
