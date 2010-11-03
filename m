Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0KCOAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:00:37 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:55525 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755338Ab0KCOAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:00:35 -0400
Date: Wed, 3 Nov 2010 15:00:33 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: guillermo arias <papaguillee18@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-pcmcia@lists.infradead.org
Subject: Re: PATCH : linux-2.6.35.4 drivers pcmcia cs.c
Message-ID: <20101103140033.GA11915@isilmar-3.linta.de>
Mail-Followup-To: guillermo arias <papaguillee18@gmail.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	linux-pcmcia@lists.infradead.org
References: <AANLkTikbEgfVZmnVfbgGxbybbghXCuUgvEm03HH=i4HD@mail.gmail.com> <20101101160529.GA9306@comet.dominikbrodowski.net> <20101101220033.416.qmail@stuge.se> <AANLkTikBh3qAifA8U9--VyXZpD-vt3cuCj0M6npD4M3D@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikBh3qAifA8U9--VyXZpD-vt3cuCj0M6npD4M3D@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Nov 02, 2010 at 03:26:42PM +0800, guillermo arias wrote:
> To Dominic Brodowski :.
> > it would enable CardBus on all PCMCIA bridges .
> comment :.
> "if (!(skt->features || SS_CAP_CARDBUS))" : refuse to enable in any
> error(1) condition from "pc or kernel" .

No, "if (!((True or False) || True))" => "if (!((True))" => "if False",
which means we enable CardBus unconditionally if your patch is used.

> To Peter Stuge :.
> >Is it certain that the hardware *is* actually cardbus capable? .
> comment :.
> was probed with vpn .
VPN?

Also, 

> >> 2) What's the output of "lspci -n -v"
> >> 3) What's the output of "sudo lspcmcia -vvv"
> >> 4) Are there any BIOS options you may toggle to enable CardBus?

Best,
	Dominik
