Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2KGSYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:24:17 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:27698 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753773Ab2KGSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:24:14 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dC56F4a69BjG5B+peXhDn
Date: Wed, 7 Nov 2012 10:24:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, arnd@arndb.de, olof@lixom.net,
        rdunlap@xenotime.net, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] ocp2scp: add non-dt support
Message-ID: <20121107182405.GH6801@atomide.com>
References: <1351844088-27059-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351844088-27059-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [121102 01:16]:
> This patch series allows ocp2scp driver to create its child devices
> from the platform data.
> 
> In omap platforms, usb phy is connected to ocp2scp and usb phy is needed
> for MUSB to be functional. When ocp2scp driver was added, it had only dt
> support which means it wont create usb phy devices for non-dt boot.
> 
> This patch series adds non-dt support to ocp2scp and this series is needed
> for getting MUSB functional in non-dt boot.

Thanks I've pushed these into omap-for-v3.7-rc4/musb-regression with
updated description to describe the regression for the -rc cycle.

Regards,

Tony
