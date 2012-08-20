Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2HTIT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:19:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:32861 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2HTITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:19:54 -0400
Message-ID: <5031F328.80702@linutronix.de>
Date: Mon, 20 Aug 2012 10:19:52 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH 2/3] usb: gadget: lpc32xx_udc: Remove usb_endpoint_descriptor
References: <1345450306-4996-1-git-send-email-stigge@antcom.de> <1345450306-4996-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1345450306-4996-2-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 10:11 AM, Roland Stigge wrote:
> This patch removes the utilization of struct usb_endpoint_descriptor, as done
> by other drivers also. This was done on request by the USB gadget maintainers,
> since this API is obsoleted.

#1 and #2 look good. #3 could use a const besides that it looks good :)

Sebastian
