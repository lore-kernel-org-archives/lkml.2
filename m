Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab2HXUHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:07:46 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:41556 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab2HXUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:07:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sSpsfDjtahpbwQNf3RsEA
Date: Fri, 24 Aug 2012 13:07:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH-V2] arm/dts: AM33XX: Set the default status of module
 to "disabled" state
Message-ID: <20120824200736.GX11011@atomide.com>
References: <1345029805-27987-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345029805-27987-1-git-send-email-hvaibhav@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaibhav Hiremath <hvaibhav@ti.com> [120815 04:24]:
> Ideally in common SoC dtsi file should set all modules
> to "disabled" state and it should get enabled in respective
> EVM/Board dts file as per usage.
> 
> This patch sets default status of all modules to "disabled"
> state in am33xx.dtsi file. Currently there are no modules
> supported as part of Bone and EVM dts support, so care
> to add entry "status = "okay"" while adding support for any
> module.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
> Changes from V1:
> 	- Fixed indentation issue caused due to extra spaces.

Thanks applying into devel-dt branch.

Tony
