Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2BVC2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:28:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43694 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab2BVC2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:28:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F4434E4.7040703@linux.intel.com>
References: <1329800140-4279-1-git-send-email-tomoya.rohm@gmail.com>
	<4F43C15D.6080401@linux.intel.com>
	<CANKRQnjMAVBf2wn01eFD1CKTgtWyhzk2_epz-YprZp3eS1wmMg@mail.gmail.com>
	<4F4434E4.7040703@linux.intel.com>
Date: Wed, 22 Feb 2012 11:28:20 +0900
Message-ID: <CANKRQnjWUXOG5igoXmJnJVHgCaFUiC=4hm63+SEWF42+izBDHA@mail.gmail.com>
Subject: Re: [PATCH] pch_uart: Change default UART clock setting 192MHz
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, feng.tang@intel.com
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年2月22日9:20 Darren Hart <dvhart@linux.intel.com>:
> Can we read the CLKCFG
> register in pch_console_setup to dynamically configure the
> port->uartclk? (not sure that's even the right place to do it).

In general implementation, as long as pch_phub is not installed,
nobody accesses the CLKCFG register.
So I think it cannot do.

Beyond general implementation,  you would access the register.

thanks
---
ROHM Co., Ltd.
tomoy
