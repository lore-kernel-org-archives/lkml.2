Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab2CACmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:42:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:27604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233Ab2CACmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:42:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="116347643"
Date: Thu, 1 Mar 2012 10:40:28 +0800
From: Feng Tang <feng.tang@intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4 V2] pch_uart: Cleanups, board quirks, and user
 uartclk parameter
Message-ID: <20120301024028.GA6612@feng-i7>
References: <cover.1330539597.git.dvhart@linux.intel.com>
 <CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com>
 <4F4EC73E.40209@linux.intel.com>
 <CANKRQnjQ4WB-ExmM5G5diw1LyA_HwySzkNyhKmf4fDLn0ZO7wg@mail.gmail.com>
 <4F4ECCE8.90207@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F4ECCE8.90207@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 05:12:08PM -0800, Darren Hart wrote:
> 
> 
> On 02/29/2012 05:06 PM, Tomoya MORINAGA wrote:
> > 2012年3月1日9:47 Darren Hart <dvhart@linux.intel.com>:
> >> how do we force the
> >> 192MHz clock setting BEFORE the pch_phub code runs?
> > 
> > To realize your requirement,
> > I think that set by BIOS is only way.
> 
> Perhaps a pch_phub.bios_uartclk parameter could be used for setting up
> the initial console and once the phub driver is loaded, it can make the
> necessary changes and fix things up in the uart port? This would add a
> binding between the pch_uart and pch_phub code.
> 
> Thoughts?

To satisfy the early console, one way may be add a x86_init_ops for all
Tunnel Creek compatible platform like what Moorestown/Medfield have done,
and insert the uart clk setting work into one of the early init function. 

Thanks,
Feng
> 
> -- 
> Darren Hart
> Intel Open Source Technology Center
> Yocto Project - Linux Kernel
