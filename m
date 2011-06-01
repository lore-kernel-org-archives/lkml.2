Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab1FAUEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:04:43 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35753 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755270Ab1FAUEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:04:41 -0400
From: Kevin Hilman <khilman@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
Subject: Re: [PATCH 2/4] arm: omap: usb: register hwmods of usbhs
Organization: Texas Instruments, Inc.
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-3-git-send-email-keshava_mgowda@ti.com>
Date: Wed, 01 Jun 2011 13:04:38 -0700
In-Reply-To: <1306934847-6098-3-git-send-email-keshava_mgowda@ti.com> (Keshava
	Munegowda's message of "Wed, 1 Jun 2011 18:57:25 +0530")
Message-ID: <87k4d5fhd5.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keshava Munegowda <keshava_mgowda@ti.com> writes:

> The hwmod structure of uhh and tll are retrived
> and registered with omap device

And the name strings are changed as well as the device identifier
changed from zero to -1.  Please comment and justify.

Kevin
