Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2BTGXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:23:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46332 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2BTGW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120220055708.GA4903@feng-i7>
References: <4F3DA617.5030805@linux.intel.com>
	<20120217072808.GA26800@feng-i7>
	<CANKRQnhfQyUrMWaXJVsjmL-yFnHa9WuR5LfTkqv=QmRGnC2aTw@mail.gmail.com>
	<4F3E9909.7010301@linux.intel.com>
	<CANKRQnihp+CO9yz3SfEL=kFO18SMUJnU_LdELViPsNmd-Ew8yw@mail.gmail.com>
	<20120220044322.GA4113@feng-i7>
	<CANKRQniP+OxrqhL=7eE1NpGf_umyA-GHLSYaiF+o-o=OT2iL_w@mail.gmail.com>
	<20120220055708.GA4903@feng-i7>
Date: Mon, 20 Feb 2012 15:22:57 +0900
Message-ID: <CANKRQnh75ay4kifp4LSHxOy+QaD9G+NJD8vuOO9e__5GbDMWmQ@mail.gmail.com>
Subject: Re: pch_uart and pch_phub clock selection
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "lkml," <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年2月20日14:57 Feng Tang <feng.tang@intel.com>:
> Great! and glad to hear that. Could you update your patch which only touches
> the EG20T UART clock setting? like taking the register setting code out of
> the "switch/case" loop. something like:

OK.
I will modify like you said and post the patch.

thanks.
---
ROHM Co., Ltd.
tomoya
