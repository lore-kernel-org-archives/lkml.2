Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2CAC1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:27:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34267 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2CAC1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:27:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.50.212.39 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4ED9F8.3010706@linux.intel.com>
References: <cover.1330539597.git.dvhart@linux.intel.com>
	<CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com>
	<4F4EC73E.40209@linux.intel.com>
	<CANKRQnjQ4WB-ExmM5G5diw1LyA_HwySzkNyhKmf4fDLn0ZO7wg@mail.gmail.com>
	<4F4ECCE8.90207@linux.intel.com>
	<CANKRQni2OpCrRys5aYqBpvDEN7dRw2xcknMQRbokLxxZ_n1EAg@mail.gmail.com>
	<4F4ED9F8.3010706@linux.intel.com>
Date: Thu, 1 Mar 2012 11:27:20 +0900
Message-ID: <CANKRQnjZKJijkwX_P3UsY4kxwQG5qDSMiLJLrGBw6aU1NRFcNg@mail.gmail.com>
Subject: Re: [PATCH 0/4 V2] pch_uart: Cleanups, board quirks, and user uartclk parameter
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年3月1日11:07 Darren Hart <dvhart@linux.intel.com>:
> Just that currently I can build pch_uart without the pch_phub driver. It
> seems if we were to attempt the above, the pch_uart code would then
> require the pch_phub driver and the pch_phub driver would need to know
> how to trigger the pch_uart code to setup the uart port again with the
> new clock setting.
Looks good If pch_phub can notify pch_uart to change clock setting.

thanks.
-- 
ROHM Co., Ltd.
tomoya
