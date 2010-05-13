Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab0EMKO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:14:28 -0400
Received: from mga12.intel.com ([143.182.124.36]:17473 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758509Ab0EMKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:14:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,221,1272870000"; 
   d="scan'208";a="276643284"
Date: Thu, 13 May 2010 10:33:40 +0100
From: Alan Cox <alan@linux.intel.com>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Driver for a SmartCard interface on a SoC
Message-ID: <20100513103340.10e4e0e3@linux.intel.com>
In-Reply-To: <201005120938.34634.jbe@pengutronix.de>
References: <201005071518.50406.jbe@pengutronix.de>
	<201005071625.27872.jbe@pengutronix.de>
	<20100511223337.05945e68@linux.intel.com>
	<201005120938.34634.jbe@pengutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> requirements to make it work. But these additional requirements are
> shared by all SmartCards. Where would be the best place/mail list to
> discuss this API?

Probably linux-kernel for the kernel view. I don't really know much
about smartcard user space to know if there is another list that might
also be useful.

If you don't get any feedback on an API you suggest I'd then just go
and implement and submit it.

> Do you mean to emulate an external serial device in the kernel driver?
> To make it understand the same data sequences these kind of external
> device understand? Would be possible, but its more complex than to
> run the communication via read()/write() and a few additional IOCTLs
> for the special SmartCard handling.

Agreed - and I don't think the extra complexity is worth it.
