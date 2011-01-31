Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1AaSGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:06:53 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:28974
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab1AaSGw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:06:52 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275bh8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/8] Basic ARM device tree support
Date: Mon, 31 Jan 2011 11:06:47 -0700
In-Reply-To: <20110131180512.GA15429@angua.secretlab.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/8] Basic ARM device tree support
Thread-Index: AcvBcW5Khf7H5njpTX2S0/3DpywUTQAABVqg
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6> <00bcd596-2108-4c54-92d3-7fda39e333e3@VA3EHSMHS015.ehs.local> <20110131180512.GA15429@angua.secretlab.ca>
From: John Linn <John.Linn@xilinx.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
X-OriginalArrivalTime: 31 Jan 2011 18:06:47.0653 (UTC) FILETIME=[A0637950:01CBC171]
X-RCIS-Action: ALLOW
Message-ID: <89a3dcf3-ee44-428d-b248-ca1853a4fc6d@VA3EHSMHS004.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant
Likely
> Sent: Monday, January 31, 2011 11:05 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org; Nicolas Pitre; Russell King;
Catalin Marinas; devicetree-
> discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; Olof
Johansson; Jeremy Kerr; Lennert
> Buijtenhek
> Subject: Re: [PATCH 0/8] Basic ARM device tree support
> 
> On Wed, Jan 26, 2011 at 01:04:39PM -0700, John Linn wrote:
> > > -----Original Message-----
> > > From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of
Grant Likely
> > > Sent: Tuesday, January 18, 2011 1:29 PM
> > > To: linux-arm-kernel@lists.infradead.org
> > > Cc: Nicolas Pitre; Russell King; Catalin Marinas;
devicetree-discuss@lists.ozlabs.org; linux-
> > > kernel@vger.kernel.org; Olof Johansson; Jeremy Kerr; John Linn;
Lennert Buijtenhek
> > > Subject: [PATCH 0/8] Basic ARM device tree support
> > >
> >
> > Thanks for this patch set.  Device tree on ARM will be a great help
to Xilinx.
> >
> > Tested-by: John Linn <john.linn@xilinx.com>
> 
> Thanks John,
> 
> I've had to rework the early init code to be safer, but it turned out
> to be a significant change, so I won't add your tested-by line to the
> patch yet.  Would you mind retesting when I repost later today?

Sure, will do.

- John

> 
> Thanks,
> g.
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


