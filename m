Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2CGRcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:32:02 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60129 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab2CGRb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:31:58 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+/7W3IctE+gaddz8DcHNkH
Date: Wed, 7 Mar 2012 09:31:52 -0800
From: Tony Lindgren <tony@atomide.com>
To: Chris Ball <cjb@laptop.org>
Cc: "T Krishnamoorthy, Balaji" <balajitk@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH 4/4] mmc: omap_hsmmc: Simplify init for twl6030 MMC
 card detect
Message-ID: <20120307173152.GG12083@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185535.29210.71546.stgit@kaulin.local>
 <4F50643B.9050500@ti.com>
 <20120302172251.GJ18901@atomide.com>
 <4F548457.5050205@ti.com>
 <CANrkHUZysOnHKKUuLm0Vbo1KsNp0yUd=udjGvQ43=gTTXbWeCw@mail.gmail.com>
 <CANrkHUaYDpv=p0p81oKWCoewyjheyZYkCqvZY7_ZQxWi_=8YFw@mail.gmail.com>
 <m2lincifj9.fsf@bob.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2lincifj9.fsf@bob.laptop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Ball <cjb@laptop.org> [120307 07:11]:
> Hi Balaji,
> 
> On Wed, Mar 07 2012, T Krishnamoorthy, Balaji wrote:
> > OMAP4 and OMAP3 HSMMC IP registers differ by 0x100 offset.
> > Addng the offset to platform_device resource structure
> > increments the start address for every insmod operation.
> > MMC command fails on re-insertion as module due incorrect register base.
> > Fix this by updating the ioremap base address only.
> >
> > Signed-off-by: Balaji T K <balajitk@ti.com>
> 
> Is this a regression, or has it never worked in mainline?

"Features that never worked originally" so this can wait for the
merge window. It happens on re-inserting of the card.
 
> > Note:  eMMC detection is still failing on resertion due to card vcc
> > power off on rmmod
> 
> And this?

That sounds like a separate issue that needs to be fixed.

Regards,

Tony
