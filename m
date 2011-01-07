Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1AGNdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:33:37 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:47335 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1AGNdg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 7 Jan 2011 08:33:36 -0500
Message-Id: <4D27243D020000780002B00C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 07 Jan 2011 13:33:33 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Robert Richter" <robert.richter@amd.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Andreas Herrmann3" <Andreas.Herrmann3@amd.com>,
        "Joerg Roedel" <Joerg.Roedel@amd.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use PCI method for enabling AMD extended
	 config space before MSR method
References: <4D26028F020000780002AC8A@vpn.id2.novell.com>
 <20110106172004.GM4739@erda.amd.com> <20110106172834.GN4739@erda.amd.com>
 <20110107125818.GB23185@elte.hu>
In-Reply-To: <20110107125818.GB23185@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.01.11 at 13:58, Ingo Molnar <mingo@elte.hu> wrote:

> * Robert Richter <robert.richter@amd.com> wrote:
> 
>> On 06.01.11 18:20:04, Robert Richter wrote:
>> > On 06.01.11 11:57:35, Jan Beulich wrote:
>> > > While both methods should work equivalently well for the native case,
>> > > the Xen Dom0 case can't reliably work with the MSR one, since there's
>> > > no guarantee that the virtual CPUs it has available fully cover all
>> > > necessary physical ones.
>> > > 
>> > > As per the suggestion of Robert Richter the patch only adds the PCI
>> > > method, but leaves the MSR one as a fallback to cover new systems the
>> > > PCI IDs of which may not have got added to the code base yet.
>> > > 
>> > > Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> > > Cc: Robert Richter <robert.richter@amd.com>
>> > > Cc: Joerg Roedel <Joerg.Roedel@amd.com>
>> > > Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
>> > > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> > > 
>> > > ---
>> > >  arch/x86/include/asm/amd_nb.h |    7 ++++++
>> > >  arch/x86/kernel/amd_nb.c      |    7 ++++++
>> > >  arch/x86/kernel/aperture_64.c |   44 +++++++++++++++---------------------------
>> > >  arch/x86/pci/amd_bus.c        |   30 ++++++++++++++++++++++++++++
>> > >  4 files changed, 60 insertions(+), 28 deletions(-)
>> 
>> Btw, the patch should be relative to tip/x86/amd-nb as there would be
>> conflicts otherwise due to other changes.
> 
> that's upstream meanwhile, so a patch against -git or -tip would suffice.

Yes, will do as soon as I can get to it.

Jan

