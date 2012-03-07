Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab2CGRVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:21:24 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42169 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2CGRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:21:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18eUKsFa3O4iI8ArU5v9eoh
Date: Wed, 7 Mar 2012 09:21:16 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russ Dill <Russ.Dill@ti.com>
Cc: Kevin Hilman <khilman@ti.com>, balbi@ti.com, Matt Porter <mporter@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120307172116.GF12083@atomide.com>
References: <1330006564-13290-1-git-send-email-mporter@ti.com>
 <87wr74gis6.fsf@ti.com>
 <20120301204553.GA21841@legolas.emea.dhcp.ti.com>
 <87pqcqnc7u.fsf@ti.com>
 <CA+Bv8XaJqL1L8F-n6skY7dHn1XAdDLRKaRjw0deLeoQ5Ao0Fhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Bv8XaJqL1L8F-n6skY7dHn1XAdDLRKaRjw0deLeoQ5Ao0Fhg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russ Dill <Russ.Dill@ti.com> [120307 07:28]:
> On Mon, Mar 5, 2012 at 12:18 PM, Kevin Hilman <khilman@ti.com> wrote:
> >
> > In either case $SUBJECT patch is already in Tony's fixes queue, so if it
> > is going be merged, then my fix above is needed also to not break
> > Overo and any other platform that has more than one smsc911x instance.
> >
> > Kevin
> 
> 
> Have you tested this fix? The only regulator consumer supply would be:
> 
> static struct regulator_consumer_supply gpmc_smsc911x_supply[] = {
>         REGULATOR_SUPPLY("vddvario", "smsc911x.0"),
>         REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
> };
> 
> I don't think the second smsc911x on the Overo, "smsc911x.1", would
> find it due to the dev_id.

Hmm yeah sounds like there's some further changes needed. Dropping
the second version from fixes until we have somebody reply with
tested-by using two smsc911x instances.

Regards,

Tony
