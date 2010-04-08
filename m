Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845Ab0DHXCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:02:15 -0400
Received: from sg2ehsobe001.messaging.microsoft.com ([207.46.51.75]:42311 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933775Ab0DHXCL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:02:11 -0400
X-SpamScore: -33
X-BigFish: VPS-33(zz1102K542N1432P98dN148cM9371Pzz1202hz46kz6d525hz2dh467h6bh61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: linux-next: build failure after merge of the final tree
Date: Thu, 8 Apr 2010 17:01:03 -0600
In-Reply-To: <20100409085918.cc984fb1.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux-next: build failure after merge of the final tree
Thread-Index: AcrXbyZi1QM9n9WOSKOwoLsFIvAlegAABiNw
References: <20100408153505.eb205158.sfr@canb.auug.org.au><20100407.232500.184442638.davem@davemloft.net><6125d80a-81d5-4699-ac6e-9408bd0c1145@SG2EHSMHS010.ehs.local> <20100409085918.cc984fb1.sfr@canb.auug.org.au>
From: John Linn <John.Linn@xilinx.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
CC: "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jtyner@cs.ucr.edu>, <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 08 Apr 2010 23:02:03.0157 (UTC) FILETIME=[808D5C50:01CAD76F]
X-RCIS-Action: ALLOW
Message-ID: <afd3df96-2991-49f2-aa74-138ce67b8103@SG2EHSMHS003.ehs.local>
X-Reverse-DNS: unknown-60-83.xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Thursday, April 08, 2010 4:59 PM
> To: John Linn
> Cc: David Miller; netdev@vger.kernel.org; linux-next@vger.kernel.org;
linux-kernel@vger.kernel.org;
> jtyner@cs.ucr.edu; grant.likely@secretlab.ca
> Subject: Re: linux-next: build failure after merge of the final tree
> 
> Hi John,
> 
> On Thu, 8 Apr 2010 08:15:12 -0600 John Linn <John.Linn@xilinx.com>
wrote:
> >
> > I'm not pushing back here, just trying to make sure I understand and
> > do it better next time :)
> >
> > I don't see that my patch has touched that part of the driver as
that
> > call was already in the driver before my patch (but maybe I'm just
> > missing it).
> >
> > My patch did change the dependency in the Kconfig so that it only
> > depends on powerpc rather than powerpc DCR and maybe that exposed
> > something that wasn't previously exposed.
> 
> Yeah, virt_to_bus() is only defined on 32bit PowerPC, not 64 bit.
> 
> CONFIG_PPC is set for both 32 and 64 bit PowerPC builds.
> --

Thanks for confirming that.  Spun a new patch (set) to hopefully take
care of that.

-- John

> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


