Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2BVJ0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:26:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:33615 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab2BVJ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:26:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110714874"
Date: Wed, 22 Feb 2012 17:25:40 +0800
From: Feng Tang <feng.tang@intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4] pch_uart: Cleanups, board quirks, and user uartclk
 parameter
Message-ID: <20120222092540.GA27282@feng-i7>
References: <cover.1329875301.git.dvhart@linux.intel.com>
 <CANKRQni9E6NO39MFSak6MjQ0DtmQeviGo966Ex9ZUvai56wCjg@mail.gmail.com>
 <4F4462B8.6030607@linux.intel.com>
 <CANKRQnhckD5Dt+0PbD3h=Ggz+U8RoDs0qUn5CgVnsYcH08tRkw@mail.gmail.com>
 <4F448DAA.6000207@linux.intel.com>
 <CANKRQngnFhTY3-YxhDH3oufbqUu5pe36Fi58DjKWm=9uTigr-A@mail.gmail.com>
 <4F44AE57.10302@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F44AE57.10302@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:59:03AM -0800, Darren Hart wrote:
> 
> 
> On 02/22/2012 12:16 AM, Tomoya MORINAGA wrote:
> > 2012年2月22日15:39 Darren Hart <dvhart@linux.intel.com>:
> >> We can add a patch to this series that sets the
> >> default to 192MHz, drops the CM-iTC quirk, and does nothing in pch_phub
> >> probe for the FRI2.
> > 
> > If you set  the clock of pch_uart as 64MHz,
> > do you need to add quirk for FRI2 to pch_phub so as to provide 64MHz clock?
> 
> I admit the value of pch_phub eludes me a bit. In my case, the firmware
> sets up the CLKCFG register, so there is no need to set it manually
> after boot. Instead, I'm making sure the pch_uart driver defaults to
> what the firmware sets up.

I think long term wise, we should suggest BIOS vendor to set the UART clk
to 192MHz in chipset's release notes, since 192MHz works on Darren's,
Tomoya's and my boards.

Thanks,
Feng

> 
> -- 
> Darren Hart
> Intel Open Source Technology Center
> Yocto Project - Linux Kernel
