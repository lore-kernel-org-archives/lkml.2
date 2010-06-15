Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab0FOTh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:37:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38112 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab0FOTh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:37:56 -0400
Date: Tue, 15 Jun 2010 21:37:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Nils Carlson <nils.carlson@ludd.ltu.se>, Andi Kleen <andi@firstfloor.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100615193754.GB12845@basil.fritz.box>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com> <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box> <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se> <20100615114135.GH6727@basil.fritz.box> <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se> <987664A83D2D224EAE907B061CE93D530143FDA773@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D530143FDA773@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even when the chip set registers are accessible, it can be very
> complex to do this for the general case (think of boards that
> support arbitrary mixing of different size/speed DIMMs - the
> BIOS may have done some interesting somersaults while computing
> which interleaving modes to use).

... and the numbers that come out of this may have no relation
to your motherboard labels at all. What do you do then? 
Read schemantics again?  Or do binary search on the DIMM again
like Eric suggested? 

For all of this a system specific mapping table is needed
and the only place to get this as a default option without 
explicit configuration for each motherboard is the BIOS.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
