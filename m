Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1DVPsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:48:07 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:40035
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755110Ab1DVPsD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:48:03 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz1803M9371O542M1432N98dK4015Lzz1202hzz8275bh8275dhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V2] tty/serial: add support for Xilinx PS UART
Date: Fri, 22 Apr 2011 09:47:59 -0600
In-Reply-To: <BANLkTimhk-szP=gbZLpRrofi2EB2YbXrqg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V2] tty/serial: add support for Xilinx PS UART
Thread-Index: AcwBA7DGZ26Ut8DRTs6mmFSa4H21IAAAAv8A
References: <90e49570-bc82-41a9-ac79-2f5007e93a2a@VA3EHSMHS018.ehs.local> <BANLkTimhk-szP=gbZLpRrofi2EB2YbXrqg@mail.gmail.com>
From: John Linn <John.Linn@xilinx.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>
X-OriginalArrivalTime: 22 Apr 2011 15:48:00.0134 (UTC) FILETIME=[A842AA60:01CC0104]
X-RCIS-Action: ALLOW
Message-ID: <edfeec92-bda0-4d02-90eb-bf4d04084c86@VA3EHSMHS024.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of
> Grant Likely
> Sent: Friday, April 22, 2011 9:41 AM
> To: John Linn
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk; greg@kroah.com
> Subject: Re: [PATCH V2] tty/serial: add support for Xilinx PS UART
> 
> On Wed, Apr 20, 2011 at 1:03 PM, John Linn <john.linn@xilinx.com>
> wrote:
> > The Xilinx PS Uart is used on the new ARM based SoC. This
> > UART is not compatible with others such that a seperate
> > driver is required.
> >
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> 
> Out of curiosity, who is the vendor of this uart IP block?  Is it new
> hardware created by xilinx for zinq, or is it provided by a third
> party.  If its from a third party it is within the realm of
> possibility that a driver already exists for it.
> 
> g.

Hi Grant,

It is an IP block from a vendor. I would like to say, but would have 
my head handed to me I'm told. I wish it wasn't that way as it's not 
helping the open source process.

I did try to review all the drivers and their registers to see if 
there was already one written before I sent the patches.  I didn't 
see one that matched as it would definitely be easier if there was.

Thanks,
John

<snip>

> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


