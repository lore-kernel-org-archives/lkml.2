Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab2GEOgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:36:41 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:35892
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467Ab2GEOgj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:36:39 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 10:36:39 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Alexander Graf <agraf@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: RE: linux-next: build failure after merge of the kvm-ppc tree
Thread-Topic: linux-next: build failure after merge of the kvm-ppc tree
Thread-Index: AQHNWnH5wFAU2MGe5kWluDBs5PAFDJcahoWAgAA3E5A=
Date: Thu, 5 Jul 2012 14:20:18 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E150339A388@039-SN1MPN1-002.039d.mgd.msft.net>
References: <20120705154929.219789032ef59f9243d0b8a5@canb.auug.org.au>
 <92A87EB2-E859-456C-85DE-7F0A4CC5F127@suse.de>
In-Reply-To: <92A87EB2-E859-456C-85DE-7F0A4CC5F127@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.213.168.166]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alexander Graf [mailto:agraf@suse.de]
> Sent: Thursday, July 05, 2012 1:03 AM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Yoder Stuart-B08248; ppc-dev
> Subject: Re: linux-next: build failure after merge of the kvm-ppc tree
> 
> 
> On 05.07.2012, at 07:49, Stephen Rothwell wrote:
> 
> > Hi Alexander,
> >
> > After merging the kvm-ppc tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> > arch/powerpc/kernel/exceptions-64s.S:479: Error: wrong number of operands
> > arch/powerpc/kernel/exceptions-64s.S:486: Error: wrong number of operands
> > arch/powerpc/kernel/exceptions-64s.S:486: Error: wrong number of operands
> > arch/powerpc/kernel/exceptions-64s.S:487: Error: wrong number of operands
> > arch/powerpc/kernel/exceptions-64s.S:487: Error: wrong number of operands
> > arch/powerpc/kernel/exceptions-64s.S:494: Error: wrong number of operands
> > arch/powerpc/kernel/exceptions-64s.S:494: Error: wrong number of operands
> >
> > Caused by commit bc8cc4993e19 ("PPC: use CURRENT_THREAD_INFO instead of
> > open coded assembly").  The fact that this patch has problems was already
> > pointed out on the linuxppc-dev mailing list and it clearly hasn't been
> > build tested.
> >
> > I have used the version of the kvm-ppc tree from next-20120703 for today.
> 
> Ah, yes, thanks. I kept the old, broken version in my tree to make sure I have the dependencies for (and
> don't forget) the (hopefully good) patches that follow on top, but was planning to replace it once we
> have a new version of the CURRENT_THREAD_INFO one.
> 
> Stuart, could you please send a new version of the CURRENT_THREAD_INFO patch?

Yes, will send that shortly.

Stuart

