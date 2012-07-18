Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2GRHf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:35:28 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:30213 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2GRHfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:35:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+rzZBLmLeBfg6x54w+Qlfu
Date: Wed, 18 Jul 2012 00:35:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, balbi@ti.com,
        Greg KH <gregkh@linuxfoundation.org>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        b-cousson@ti.com, rnayak@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for
 ocp2scp
Message-ID: <20120718073507.GL6522@atomide.com>
References: <1340370942-23201-1-git-send-email-kishon@ti.com>
 <20120716081204.GI7955@arwen.pp.htv.fi>
 <CAAe_U6JMGP3jEkkd=vqpR5KTeOnY51AOcb65zqKRRa8MtnWjzQ@mail.gmail.com>
 <201207161947.01751.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207161947.01751.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120716 12:51]:
> On Monday 16 July 2012, ABRAHAM, KISHON VIJAY wrote:
> > >>
> > >> I think we should reconsider the idea of drivers/bus/ with a file per
> > >> bus in there at least for new buses, but doing a new drivers/scp/
> > >> would be ok for me if there is enough opposition against the idea
> > >> of drivers/bus aggregating different buses.
> > >
> > > I don't mind either way. The fact is that this ocp-to-scp bridge is
> > > really a TI/OMAP thing. Not sure it deserves a directory of its own.
> > 
> > Ok. Then I'll have a file in drivers/bus/ for ocp2scp driver.
> 
> Sounds good to me. I don't care if it's the only file in that directory.
> We can point the next person to a bus with a single file to that directory
> and let them add theirs.

Yes great. Sounds like that's where the omap GPMC bus driver should
end up going eventually.

Regards,

Tony
