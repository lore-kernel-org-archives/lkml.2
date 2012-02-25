Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2BYODv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 09:03:51 -0500
Received: from antcom.de ([188.40.178.216]:37368 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab2BYODu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 09:03:50 -0500
Message-ID: <4F48EA42.70408@antcom.de>
Date: Sat, 25 Feb 2012 15:03:46 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
References: <1330030639-3796-1-git-send-email-stigge@antcom.de> <4F46AA06.30502@antcom.de> <20120224063521.GA16412@pengutronix.de> <201202241503.27406.arnd@arndb.de> <20120225035128.GA4455@pengutronix.de>
In-Reply-To: <20120225035128.GA4455@pengutronix.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/02/12 04:51, Wolfram Sang wrote:
>> Unfortunately, the way that ohci handles the abstraction between
>> the various implementations is backwards, it would be much easier
>> if the main driver was following that model to start with.
> 
> ... exactly for that reason I didn't suggest it. Looking at other
> ohci-sources (e.g. ohci-omap.c), machine_is_* seems to be the
> consistent use-case.

OK, considering this, I for now used machine_is_*() to get rid of the
#ifdefs.

Using platform_device_id.driver_data as Arnd suggested is also a good
idea, and switching to it will be easy when it is due.

Thanks in advance,

Roland
