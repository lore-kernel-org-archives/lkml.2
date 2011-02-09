Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963Ab1BIFms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 00:42:48 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:29924
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab1BIFmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 00:42:46 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zz542N1432N9371Pzz1202hzz1497iz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGC574-01-JUY-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: linux-next: manual merge of the usb tree with Linus' tree
Date: Wed, 9 Feb 2011 13:42:36 +0800
Message-ID: <2DEEA3AB13739D45A22ADDB5086AEA0BF08682@sshaexmb1.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux-next: manual merge of the usb tree with Linus' tree
Thread-Index: AcvGfKY3QEvQ3wLSQ8ygr9GxX6xg3QBhJSPwAAaOpjA=
References: <20110207150802.4869bd47.sfr@canb.auug.org.au> 
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "He, Alex" <Alex.He@amd.com>, Alan Stern <stern@rowland.harvard.edu>
X-OriginalArrivalTime: 09 Feb 2011 05:42:40.0065 (UTC) FILETIME=[2A11F310:01CBC81C]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just found that the patch is already in linux-next branch.

The patch "USB host: Move AMD PLL quirk to pci-quirks.c" already covers
the patch "USB: EHCI: ASPM quirk of ISOC on AMD Hudson", so with the
quirk moving patch, the EHCI ASPM patch is not needed. When I submit the
quirk moving patchset, the EHCI ASPM patch has not been merged into
linux-next. Sorry for the confliction.

Do I still need to resend the quirk moving patchset? 

Thanks & Best regards,
Andiry
 

> -----Original Message-----
> From: Xu, Andiry
> Sent: Wednesday, February 09, 2011 10:31 AM
> To: 'Stephen Rothwell'; Greg KH
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; He,
Alex;
> 'Alan Stern'
> Subject: RE: linux-next: manual merge of the usb tree with Linus' tree
> 
> Hi,
> 
> I'll resend the PLL quirk moving patchset based on the latest
linux-next
> tree.
> 
> Thanks & Best regards,
> Andiry
> 
> > -----Original Message-----
> > From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> > Sent: Monday, February 07, 2011 12:08 PM
> > To: Greg KH
> > Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Xu,
Andiry;
> > He, Alex
> > Subject: linux-next: manual merge of the usb tree with Linus' tree
> >
> > Hi Greg,
> >
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/host/ehci-pci.c between commit
> > baab93afc2844b68d57b0dcca5e1d34c5d7cf411 ("USB: EHCI: ASPM quirk of
ISOC
> > on AMD Hudson") from Linus' tree and commit
> > b7d5b439b7a40dd0a0202fe1c118615a3fcc3b25 ("USB host: Move AMD PLL
quirk
> > to pci-quirks.c") from the usb tree.
> >
> > I just use the version from the usb tree, but this may need fixing
up in
> > pci-quirks.c.
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > http://www.canb.auug.org.au/~sfr/

