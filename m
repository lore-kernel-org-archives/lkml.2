Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab2CABMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:12:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:36989 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab2CABMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:12:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72069679"
Message-ID: <4F4ECCE8.90207@linux.intel.com>
Date: Wed, 29 Feb 2012 17:12:08 -0800
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
References: <cover.1330539597.git.dvhart@linux.intel.com> <CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com> <4F4EC73E.40209@linux.intel.com> <CANKRQnjQ4WB-ExmM5G5diw1LyA_HwySzkNyhKmf4fDLn0ZO7wg@mail.gmail.com>
In-Reply-To: <CANKRQnjQ4WB-ExmM5G5diw1LyA_HwySzkNyhKmf4fDLn0ZO7wg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/29/2012 05:06 PM, Tomoya MORINAGA wrote:
> 2012年3月1日9:47 Darren Hart <dvhart@linux.intel.com>:
>> how do we force the
>> 192MHz clock setting BEFORE the pch_phub code runs?
> 
> To realize your requirement,
> I think that set by BIOS is only way.

Perhaps a pch_phub.bios_uartclk parameter could be used for setting up
the initial console and once the phub driver is loaded, it can make the
necessary changes and fix things up in the uart port? This would add a
binding between the pch_uart and pch_phub code.

Thoughts?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
