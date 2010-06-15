Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab0FOIH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:07:56 -0400
Received: from mother.ludd.ltu.se ([130.240.16.3]:37355 "EHLO
	mother.ludd.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab0FOIHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:07:52 -0400
Date: Tue, 15 Jun 2010 10:06:33 +0200 (MEST)
From: Nils Carlson <nils.carlson@ludd.ltu.se>
X-X-Sender: pyssling@dexter.ludd.ltu.se
To: Andi Kleen <andi@firstfloor.org>
cc: Doug Thompson <norsk5@yahoo.com>, Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nils Carlson <nils.carlson@ludd.ltu.se>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Subject: Re: Hardware Error Kernel Mini-Summit
In-Reply-To: <20100615065630.GC6727@basil.fritz.box>
Message-ID: <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
 <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010, Andi Kleen wrote:

> On Mon, Jun 14, 2010 at 04:46:40PM -0700, Doug Thompson wrote:
>
> Hi Doug,
>
> >
> > Maybe I didn't see it covered (or I missed it), but EDAC is used on more than just x86 based machines, though they are the majority by volume. We should have an abstraction that covers all the archs, like we do with other subsystems of Linux.
>
> The way I envision it to working is that a abstracted dimm interface
> (or edac2 or whatever you want to call it) can be fed from any reasonable
> DIMM layout driver. This could be either DMI on x86 or some other
> driver. There would be nothing really x86 specific about that.

Could you maybe provide some references on how DIMM layout
could be read from DMI? I can't find anything nearly this specific,
or is it something we're expecting to happen in future BIOS's?

Also, there would probably need to be some standard describing
different DIMM layouts in general, though maybe such a thing exists.

In other words, there would be have to be some way of ascertaining
that the info you read from DMI is sufficient to decode MCEs so that
a faulting DIMM can be identified. In an ideal world, this could
be tested by some simple tool that could be run by the BIOS writers
to test that they're providing the OS with sufficient info.

/Nils
