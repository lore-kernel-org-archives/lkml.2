Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1BNOmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:42:36 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:23665
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753636Ab1BNOmd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:42:33 -0500
X-SpamScore: -26
X-BigFish: VPS-26(zz542N1432N98dN9371Pzz1202hzzz2dh95h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V2 3/4] ARM: Xilinx: base header files and assemblymacros
Date: Mon, 14 Feb 2011 07:42:24 -0700
In-Reply-To: <20110212121609.GI15616@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V2 3/4] ARM: Xilinx: base header files and assemblymacros
Thread-Index: AcvKrqa32NDRc6vwSBS9yGH1900z6QBpq3XA
References: <1297270845-18802-1-git-send-email-john.linn@xilinx.com> <1297270845-18802-2-git-send-email-john.linn@xilinx.com> <1297270845-18802-3-git-send-email-john.linn@xilinx.com> <e19bc079-5f8a-4622-b7cd-668cede3cb97@VA3EHSMHS032.ehs.local> <20110212121609.GI15616@n2100.arm.linux.org.uk>
From: John Linn <John.Linn@xilinx.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <catalin.marinas@arm.com>, <glikely@secretlab.ca>
X-OriginalArrivalTime: 14 Feb 2011 14:42:25.0575 (UTC) FILETIME=[65675B70:01CBCC55]
X-RCIS-Action: ALLOW
Message-ID: <1bbbc116-1107-46fe-8dbc-daa3c798d76e@VA3EHSMHS027.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Saturday, February 12, 2011 5:16 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; catalin.marinas@arm.com;
> glikely@secretlab.ca
> Subject: Re: [PATCH V2 3/4] ARM: Xilinx: base header files and
assemblymacros
> 
> On Wed, Feb 09, 2011 at 10:00:44AM -0700, John Linn wrote:
> > +#ifndef __MACH_VMALLOC_H__
> > +#define __MACH_VMALLOC_H__
> > +
> > +#define VMALLOC_END       0xE0000000
> 
> Should have a UL suffix on this.

OK, easy to fix.

Thanks for another review Russell, appreciate your time and help.

-- John

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


