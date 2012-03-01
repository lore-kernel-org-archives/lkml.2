Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2CACIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:08:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:56466 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2CACI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:08:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="116339130"
Message-ID: <4F4ED9F8.3010706@linux.intel.com>
Date: Wed, 29 Feb 2012 18:07:52 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4 V2] pch_uart: Cleanups, board quirks, and user uartclk
 parameter
References: <cover.1330539597.git.dvhart@linux.intel.com> <CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com> <4F4EC73E.40209@linux.intel.com> <CANKRQnjQ4WB-ExmM5G5diw1LyA_HwySzkNyhKmf4fDLn0ZO7wg@mail.gmail.com> <4F4ECCE8.90207@linux.intel.com> <CANKRQni2OpCrRys5aYqBpvDEN7dRw2xcknMQRbokLxxZ_n1EAg@mail.gmail.com>
In-Reply-To: <CANKRQni2OpCrRys5aYqBpvDEN7dRw2xcknMQRbokLxxZ_n1EAg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/29/2012 06:06 PM, Tomoya MORINAGA wrote:
> 2012年3月1日10:12 Darren Hart <dvhart@linux.intel.com>:
>> Perhaps a pch_phub.bios_uartclk parameter could be used for setting up
>> the initial console and once the phub driver is loaded, it can make the
>> necessary changes and fix things up in the uart port?
> 
> Yes, once phub driver is installed, uart works with new clock set by phub.
> 
>> This would add a binding between the pch_uart and pch_phub code.
> What does the above "binding" mean ?
> 

Just that currently I can build pch_uart without the pch_phub driver. It
seems if we were to attempt the above, the pch_uart code would then
require the pch_phub driver and the pch_phub driver would need to know
how to trigger the pch_uart code to setup the uart port again with the
new clock setting.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
