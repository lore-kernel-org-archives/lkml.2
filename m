Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2G3JiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:38:09 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:56325 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab2G3JiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:38:05 -0400
Message-ID: <501655F2.7070900@ti.com>
Date: Mon, 30 Jul 2012 15:07:54 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
References: <1343639400-28725-1-git-send-email-kishon@ti.com> <1343639400-28725-2-git-send-email-kishon@ti.com>
In-Reply-To: <1343639400-28725-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2012 02:39 PM, Kishon Vijay Abraham I wrote:
> +			writel(~PHY_PD, phy->control_dev);
> +			/* XXX: add proper documentation for this delay */
> +			mdelay(200);
Do you need this to be busy?
