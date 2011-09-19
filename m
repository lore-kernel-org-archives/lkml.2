Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1ISAVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 20:21:03 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42685 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab1ISAVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 20:21:01 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] RapidIO: documentation update
Date: Sun, 18 Sep 2011 17:20:38 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552021F93AE@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4E7470E6.2000404@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] RapidIO: documentation update
Thread-Index: Acx1IsCqwZ9EJlhyQt6E3G+Y1MoAPABPXGiQ
References: <1316092759-5460-1-git-send-email-alexandre.bounine@idt.com> <4E7470E6.2000404@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Micha Nelissen <micha@neli.hopto.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, Liu Gang <Gang.Liu@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> >  After the host has completed enumeration of the entire network it
releases
> >  devices by clearing device ID locks (calls rio_clear_locks()). For
each endpoint
> > -in the system, it sets the Master Enable bit in the Port General
Control CSR
> > +in the system, it sets the Discovered bit in the Port General
Control CSR
> >  to indicate that enumeration is completed and agents are allowed to
execute
> >  passive discovery of the network.
> 
> The host needs to set both. Without Master Enable an agent is not
> supposed to initiate transactions on the "bus", that's the meaning of
> that bit.

This is correct and host set both bits: Master_Enable and Discovered.
The documentation change above is related to event that triggers
discovery process.
In this context the change shown above is sufficient.
Please see the original code patch submitted by Liu Gang.

Alex.
   
