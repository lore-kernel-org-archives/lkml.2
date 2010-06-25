Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0FYXgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:36:47 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:18696 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756015Ab0FYXgq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:36:46 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz542N1432N98dN9371Pzz1202hzzz2dh61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
Date: Fri, 25 Jun 2010 16:36:21 -0700
In-Reply-To: <AANLkTik_lg0H4-ajyuCmH9LwhY0nAfo4-sax8ETC984h@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
Thread-Index: AcsUvv6gzyhhf1rTSKyQsPyDfqz3AQAACv/A
References: <20100625220300.6903.3519.stgit@angua> <b392c10f-78bb-466d-a3e0-cf5b95edb4cb@VA3EHSMHS014.ehs.local> <AANLkTilvOpCVrbT4YPaw3NZUCnKgUN7IUQzQGMfihbSG@mail.gmail.com> <bb9a6620-ccf1-4f5b-a1cd-97f93bad4baa@SG2EHSMHS007.ehs.local> <AANLkTik_lg0H4-ajyuCmH9LwhY0nAfo4-sax8ETC984h@mail.gmail.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
CC: <benh@kernel.crashing.org>, <monstr@monstr.eu>,
       <microblaze-uclinux@itee.uq.edu.au>,
       <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <jeremy.kerr@canonical.com>, <sfr@canb.auug.org.au>
X-OriginalArrivalTime: 25 Jun 2010 23:36:37.0571 (UTC) FILETIME=[41385130:01CB14BF]
X-RCIS-Action: ALLOW
Message-ID: <5facd128-d48a-4b9e-9b4e-83cabcf33921@SG2EHSMHS003.ehs.local>
X-Reverse-DNS: unknown-60-83.xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> Sent: Friday, June 25, 2010 4:34 PM
> To: Stephen Neuendorffer
> Cc: benh@kernel.crashing.org; monstr@monstr.eu; microblaze-uclinux@itee.uq.edu.au; devicetree-
> discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; jeremy.kerr@canonical.com;
> sfr@canb.auug.org.au
> Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
> 
> On Fri, Jun 25, 2010 at 5:18 PM, Stephen Neuendorffer
> <stephen.neuendorffer@xilinx.com> wrote:
> >> -----Original Message-----
> >> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> >> Sent: Friday, June 25, 2010 4:16 PM
> >> To: Stephen Neuendorffer
> >> Cc: benh@kernel.crashing.org; monstr@monstr.eu; microblaze-uclinux@itee.uq.edu.au; devicetree-
> >> discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; jeremy.kerr@canonical.com;
> >> sfr@canb.auug.org.au
> >> Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
> >>
> >> On Fri, Jun 25, 2010 at 4:49 PM, Stephen Neuendorffer
> >> <stephen.neuendorffer@xilinx.com> wrote:
> >> > Grant,
> >> >
> >> > I need this for the PCI project.  I also have a couple of other
> >> > generalizations of the drivers/of code
> >> > to get it to run after boot time in an X86 system...
> >>
> >> Send me your patches!  :-)  Get them to me soon and I'll queue them up
> >> for the next merge window.
> >>
> >> g.
> >
> > Dangit, I just got the code compiling, and now I find out that X86 doesn't support out_be32()...  :)
> > You'd think that somewhere somebody might have realized that all the duplicated driver macros that
> > do that are a bad idea...
> 
> :-)
> 
> I think iowrite32be should be cross-arch safe.  in_*, out_* was mostly
> a powerpc/sparc thing.
> 
> g.

See.. I told you it was a good idea to have that abstracted.. :)

S

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


