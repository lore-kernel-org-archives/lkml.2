Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab1FAUFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:05:19 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:51866 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759971Ab1FAUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:05:13 -0400
From: Kevin Hilman <khilman@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: Re: [PATCH 3/4] arm: omap: usb: device name change for the clk names of usbhs
Organization: Texas Instruments, Inc.
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-3-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-4-git-send-email-keshava_mgowda@ti.com>
Date: Wed, 01 Jun 2011 13:05:07 -0700
In-Reply-To: <1306934847-6098-4-git-send-email-keshava_mgowda@ti.com> (Keshava
	Munegowda's message of "Wed, 1 Jun 2011 18:57:26 +0530")
Message-ID: <87hb89fhcc.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keshava Munegowda <keshava_mgowda@ti.com> writes:

> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>
> device name usbhs clocks are changed from
> usbhs-omap.0 to usbhs_omap; this is because
> in the hwmod registration the device name is set
> as usbhs_omap

..and because the identifier is changed to -1 in the previous patch
without being documented.

Kevin
