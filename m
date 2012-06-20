Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2FTKor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:44:47 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:22605 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2FTKop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:44:45 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19IqqB6NgjY+BS2Oy+zmJgj
Date: Wed, 20 Jun 2012 03:44:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com
Subject: Re: [RFC PATCH 3/3] arm: omap: phy: remove unused functions from
 omap-phy-internal.c
Message-ID: <20120620104440.GE12766@atomide.com>
References: <1338388466-3565-1-git-send-email-kishon@ti.com>
 <1338388466-3565-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338388466-3565-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [120530 07:38]:
> All the unnessary functions in omap-phy-internal is removed.
> These functionality are now handled by omap-usb2 phy driver.

Glad to see these move to live under drivers. Up to Felipe
to merge via linux-usb once the driver parts are finished:

Acked-by: Tony Lindgren <tony@atomide.com>
