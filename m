Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2JLVwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:52:08 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50197 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752512Ab2JLVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:52:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MUlvPijOAZ8H6z6hNXvPr
Date: Fri, 12 Oct 2012 14:51:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sourav <sourav.poddar@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
Message-ID: <20121012215156.GL30339@atomide.com>
References: <20120925092118.GJ31374@n2100.arm.linux.org.uk>
 <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
 <87ipas2y4h.fsf@deeprootsystems.com>
 <alpine.DEB.2.00.1210111748010.5736@utopia.booyaka.com>
 <50784458.9080806@ti.com>
 <877gqv7imt.fsf@deeprootsystems.com>
 <20121012164202.GQ28061@n2100.arm.linux.org.uk>
 <877gqv4lmt.fsf@deeprootsystems.com>
 <20121012185426.GS28061@n2100.arm.linux.org.uk>
 <87lifbwhwd.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lifbwhwd.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@deeprootsystems.com> [121012 13:34]:
>
> I'm not conviced (yet) that a mismatch is the root cause.  Yes, that's
> what the author of $SUBJECT patch assumed and stated, but I'm not
> pursuaded.  
> 
> If it's an improperly configured mux issue, then the UART will break
> whenever the device is actually omap_device_enable'd, whether in the
> driver or in the bus layer.

I tried booting n800 here with CONFIG_OMAP_MUX disabled, and no
change. Serial console output stops right when the console initializes.

Regards,

Tony
