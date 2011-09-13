Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1IMGoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 02:44:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab1IMGoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 02:44:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Mark Salter <msalter@redhat.com>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/24] C6X: devicetree
Date: Tue, 13 Sep 2011 08:43:56 +0200
Message-ID: <6360771.ouEC5EKNMR@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1315869636.11280.26.camel@deneb.redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com> <20110912201102.GF23345@ponder.secretlab.ca> <1315869636.11280.26.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ywQ+FLr7+hyi7HcqQJL/y7QP7qIqtQWZzmLPN/+k/EA
 1Og/kdJIakqqDKYmvbKjHWveAUGIrhJs4oMps4VHVIO0l3lBfq
 7ESIizxfIvXKHKubuBxSL3Cpp4YBpg66ZQ+PgbYyZC7noo4aDo
 RZiiyXduuZnZSQtZxZANKPSGTFhrMnuA9QDh2WPm9wwZDnVZzX
 qT9hbwU6nI6aVTOdFiHpG9/dM+X/nptiKCZ8pTE1YjtUukoWUf
 Moe2zCqknvKTycKDtIAdWnRlTihfrknwewKNjORfrrWC8Y7eF2
 FWtInrjcyb/q0QaWOjUcVv3wsYhhk6AIrC4wU8DiXS8uanTLIs
 FiZTT3P0ELAxewS3CTIE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 September 2011 19:20:35 Mark Salter wrote:
> On Mon, 2011-09-12 at 14:11 -0600, Grant Likely wrote:
> > On Wed, Aug 31, 2011 at 05:26:41PM -0400, Mark Salter wrote:
> > > +           interrupt-controller;
> > > +           #interrupt-cells = <1>;
> > > +           compatible = "ti,c64x+core-pic";
> > 
> > The interrupt controller isn't addressable?  Is it integrated into
> > the CPU?
> 
> Yes, that core controller is controlled through registers accessed
> with special-purpose instructions, not MMIO. Other controllers, like
> megamodule and some as-yet unimplemented use MMIO.

Are these instructions specific to the interrupt controller or
do they access a register space that can contain arbitrary
devices?

If there is a separate address space for special devices, it might
be good to describe that in the device tree, like we do for PCI
I/O space.

	Arnd
