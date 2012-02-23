Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab2BWVFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:05:18 -0500
Received: from antcom.de ([188.40.178.216]:60711 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab2BWVFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:05:15 -0500
Message-ID: <4F46AA06.30502@antcom.de>
Date: Thu, 23 Feb 2012 22:05:10 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
References: <1330030639-3796-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1330030639-3796-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/12 21:57, Roland Stigge wrote:
> This patch adds OHCI support to the LPC32xx ARM platform

To get rid of the remaining #ifdefs, I could as well create a new
ohci-lpc32xx.c instead of abusing ohci-pnx4008.c. Would this be the way
to go or are there any other suggestions?

Thanks in advance,

Roland
