Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2BWVL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:11:26 -0500
Received: from antcom.de ([188.40.178.216]:32878 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab2BWVLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:11:25 -0500
Message-ID: <4F46AB7B.7010306@antcom.de>
Date: Thu, 23 Feb 2012 22:11:23 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: LPC32xx: USB Support
References: <1330030842-3848-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1330030842-3848-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 23/02/12 22:00, Roland Stigge wrote:
> This patch adds OHCI support to the LPC32xx ARM platform. Besides the trivial
> addition of platform "usb-ohci" support, fixes for the USB PLL have been added
> to arch/arm/mach-lpc32xx/clock.c, ported from NXP's lpclinux.com.

This applies on top of my LPC32xx base patch series recently integrated
into arm-soc. I can prepare a patch to apply cleanly to current
mainline, if necessary (please note that without the cited basic
patches, mach-lpc32xx would be seriously broken, anyway).

Thanks in advance,

Roland
