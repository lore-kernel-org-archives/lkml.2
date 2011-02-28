Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1B1OOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:14:39 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53786
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab1B1OOi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:14:38 -0500
X-SpamScore: -35
X-BigFish: VPS-35(zz1803M542N1432N98dN4015L9371Pzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4 2/4] ARM: Xilinx: Adding timer support to the platform
Date: Mon, 28 Feb 2011 07:14:31 -0700
In-Reply-To: <20110228111156.GB8751@pulham.picochip.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4 2/4] ARM: Xilinx: Adding timer support to the platform
Thread-Index: AcvXOFMfMS6tMtNxQWmFKpe4yUEk4AAGVsCw
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <1298052881-14591-2-git-send-email-john.linn@xilinx.com> <a7f0ed14-296f-450d-af78-6771cd7281d1@VA3EHSMHS022.ehs.local> <20110228111156.GB8751@pulham.picochip.com>
From: John Linn <John.Linn@xilinx.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>,
        Kiran Sutariya <kiran.sutariya@einfochips.com>
X-OriginalArrivalTime: 28 Feb 2011 14:14:32.0290 (UTC) FILETIME=[D1D4D420:01CBD751]
X-RCIS-Action: ALLOW
Message-ID: <7d2af02a-d0ab-49b4-a4f9-65718057dc9c@VA3EHSMHS030.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jamie Iles [mailto:jamie@jamieiles.com]
> Sent: Monday, February 28, 2011 4:12 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; linux@arm.linux.org.uk;
> catalin.marinas@arm.com; glikely@secretlab.ca; jamie@jamieiles.com;
arnd@arndb.de; Kiran Sutariya
> Subject: Re: [PATCH V4 2/4] ARM: Xilinx: Adding timer support to the
platform
> 
> On Fri, Feb 18, 2011 at 11:14:39AM -0700, John Linn wrote:
> > The timer driver supports the Xilinx PS Timer Counter IP.
> >
> > Signed-off-by: Kiran Sutariya <kiran.sutariya@einfochips.com>
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> > ---
> 
> Looks nice to me.  It may be worth adding sched_clock() support to get
> better scheduler resolution in the future but that could come as a
> separate patch.

Yes will do that as an update patch later, good suggestion.

Thanks,
John

> 
> Jamie


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


