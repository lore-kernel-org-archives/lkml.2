Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2BVI7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:59:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:8236 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab2BVI7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:59:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68992689"
Message-ID: <4F44AE57.10302@linux.intel.com>
Date: Wed, 22 Feb 2012 00:59:03 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4] pch_uart: Cleanups, board quirks, and user uartclk
 parameter
References: <cover.1329875301.git.dvhart@linux.intel.com> <CANKRQni9E6NO39MFSak6MjQ0DtmQeviGo966Ex9ZUvai56wCjg@mail.gmail.com> <4F4462B8.6030607@linux.intel.com> <CANKRQnhckD5Dt+0PbD3h=Ggz+U8RoDs0qUn5CgVnsYcH08tRkw@mail.gmail.com> <4F448DAA.6000207@linux.intel.com> <CANKRQngnFhTY3-YxhDH3oufbqUu5pe36Fi58DjKWm=9uTigr-A@mail.gmail.com>
In-Reply-To: <CANKRQngnFhTY3-YxhDH3oufbqUu5pe36Fi58DjKWm=9uTigr-A@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/22/2012 12:16 AM, Tomoya MORINAGA wrote:
> 2012年2月22日15:39 Darren Hart <dvhart@linux.intel.com>:
>> We can add a patch to this series that sets the
>> default to 192MHz, drops the CM-iTC quirk, and does nothing in pch_phub
>> probe for the FRI2.
> 
> If you set  the clock of pch_uart as 64MHz,
> do you need to add quirk for FRI2 to pch_phub so as to provide 64MHz clock?

I admit the value of pch_phub eludes me a bit. In my case, the firmware
sets up the CLKCFG register, so there is no need to set it manually
after boot. Instead, I'm making sure the pch_uart driver defaults to
what the firmware sets up.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
