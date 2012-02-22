Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2BVXKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:10:24 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47317 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2BVXKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:10:17 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/3FCyi5aXzrv8Z0KqvhAeG
Date: Wed, 22 Feb 2012 15:10:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120222231012.GW18185@atomide.com>
References: <1329929103-28486-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329929103-28486-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [120222 08:13]:
> This fixes smsc911x support on platforms using gpmc_smsc911x_init().
> 
> Commit c7e963f6888816 (net/smsc911x: Add regulator support) added
> the requirement that platforms provide vdd33a and vddvario supplies.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
> Changes for v2:
>    - temporary fix to avoid platform device id conflicts
>    - add commit summary from the smsc911x regulator support commit
>    - incorporate platform device registration error cause reporting 

Thanks applying into fixes.

Tony
