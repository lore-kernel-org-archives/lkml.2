Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab1FAT56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:57:58 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42791 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932240Ab1FAT5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:57:55 -0400
From: Kevin Hilman <khilman@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
Subject: Re: [PATCH 1/4] arm: omap: usb: ehci and ohci hwmod structures for omap3 and omap4
Organization: Texas Instruments, Inc.
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
Date: Wed, 01 Jun 2011 12:56:44 -0700
In-Reply-To: <1306934847-6098-2-git-send-email-keshava_mgowda@ti.com> (Keshava
	Munegowda's message of "Wed, 1 Jun 2011 18:57:24 +0530")
Message-ID: <87hb89gwar.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keshava Munegowda <keshava_mgowda@ti.com> writes:

> Following 2 hwmod strcuture are added:
> UHH hwmod of usbhs with uhh base address and
> EHCI , OHCI irq and base addresses.
> TLL hwmod of usbhs with the TLL base address and irq.
>
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

I believe the OMAP4 data came from Benoit, so should be in a patch with
his authorship and signoff.  OMAP3 can be a separate patch with your
authorship.

Kevin
