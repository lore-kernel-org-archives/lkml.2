Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2CACGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:06:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50630 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2CACGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:06:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.50.104.166 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4ECCE8.90207@linux.intel.com>
References: <cover.1330539597.git.dvhart@linux.intel.com>
	<CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com>
	<4F4EC73E.40209@linux.intel.com>
	<CANKRQnjQ4WB-ExmM5G5diw1LyA_HwySzkNyhKmf4fDLn0ZO7wg@mail.gmail.com>
	<4F4ECCE8.90207@linux.intel.com>
Date: Thu, 1 Mar 2012 11:06:18 +0900
Message-ID: <CANKRQni2OpCrRys5aYqBpvDEN7dRw2xcknMQRbokLxxZ_n1EAg@mail.gmail.com>
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

2012年3月1日10:12 Darren Hart <dvhart@linux.intel.com>:
> Perhaps a pch_phub.bios_uartclk parameter could be used for setting up
> the initial console and once the phub driver is loaded, it can make the
> necessary changes and fix things up in the uart port?

Yes, once phub driver is installed, uart works with new clock set by phub.

> This would add a binding between the pch_uart and pch_phub code.
What does the above "binding" mean ?

ROHM Co., Ltd.
tomoya
