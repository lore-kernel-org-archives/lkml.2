Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2HTI0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:26:35 -0400
Received: from antcom.de ([188.40.178.216]:43709 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab2HTI0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:26:33 -0400
Message-ID: <5031F4B5.300@antcom.de>
Date: Mon, 20 Aug 2012 10:26:29 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH 2/3] usb: gadget: lpc32xx_udc: Remove usb_endpoint_descriptor
References: <1345450306-4996-1-git-send-email-stigge@antcom.de> <1345450306-4996-2-git-send-email-stigge@antcom.de> <5031F328.80702@linutronix.de>
In-Reply-To: <5031F328.80702@linutronix.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 10:19 AM, Sebastian Andrzej Siewior wrote:
> On 08/20/2012 10:11 AM, Roland Stigge wrote:
>> This patch removes the utilization of struct usb_endpoint_descriptor,
>> as done
>> by other drivers also. This was done on request by the USB gadget
>> maintainers,
>> since this API is obsoleted.
> 
> #1 and #2 look good. #3 could use a const besides that it looks good :)

Thanks for reviewing! Reposting.

Roland
