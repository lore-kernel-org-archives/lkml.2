Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2BVE0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 23:26:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2BVE0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 23:26:36 -0500
MIME-Version: 1.0
In-Reply-To: <4F4462B8.6030607@linux.intel.com>
References: <cover.1329875301.git.dvhart@linux.intel.com>
	<CANKRQni9E6NO39MFSak6MjQ0DtmQeviGo966Ex9ZUvai56wCjg@mail.gmail.com>
	<4F4462B8.6030607@linux.intel.com>
Date: Wed, 22 Feb 2012 13:26:36 +0900
Message-ID: <CANKRQnhckD5Dt+0PbD3h=Ggz+U8RoDs0qUn5CgVnsYcH08tRkw@mail.gmail.com>
Subject: Re: [PATCH 0/4] pch_uart: Cleanups, board quirks, and user uartclk parameter
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年2月22日12:36 Darren Hart <dvhart@linux.intel.com>:
> This patch series allows for a functional early serial console as well
> as using the UART after boot. It leaves the CM-iTC board alone. So this
> seems to enable all use cases, while forcing 192MHz breaks the FRI2
> early serial console. I don't see an advantage to that approach other
> than the obviously simpler code (which is nice, but should not trump
> functionality).

Your quark "Fish River Island II" is OK.
My concern is default uart_clock remains 1.8432 MHz.
Like I said the advantage before, I think this should be 192MHz not 1.8432 MHz.

Or do you have any reason 1.8432 MHz should be set as PCH_UART default  clock.

thanks
---
ROHM Co., Ltd.
tomoya
