Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2JKOlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:41:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11462 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751172Ab2JKOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:41:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/H3vc6qvpum8hG8zKV0FlZ
Date: Thu, 11 Oct 2012 07:41:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ivan Djelic <ivan.djelic@parrot.com>
Cc: "Philip, Avinash" <avinashphilip@ti.com>, afzal@ti.com,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] mtd: nand: omap2: Add data correction support
Message-ID: <20121011144137.GA12552@atomide.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
 <1349274589-11389-5-git-send-email-avinashphilip@ti.com>
 <20121003192044.GB27502@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9B8A65@DBDE01.ent.ti.com>
 <20121005142338.GA7199@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9CA829@DBDE01.ent.ti.com>
 <20121010170806.GB13585@parrot.com>
 <518397C60809E147AF5323E0420B992E3E9CB751@DBDE01.ent.ti.com>
 <20121011082149.GA15609@parrot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011082149.GA15609@parrot.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ivan Djelic <ivan.djelic@parrot.com> [121011 01:23]:
> 
> I don't know which way is better for the OMAP community:
> 1. Unifying ECC modes = loosing the constant polynomial benefits, but gaining RBL compat and simplifying code
> 2. Keeping separate ECC modes = code bloat
> 
> Tony, do you have an opinion on this ?

Well right now I'm mostly interested in making device
drivers independent of the arch/arm/*omap*/* code.
That's where Afzal's patches help quite a bit, so let's
get those in first. So from that point of view, option #1
above sounds better as the first step :)

Ideally of course option #1 should not limit us from
adding extra features in the long run.

Regards,

Tony 
