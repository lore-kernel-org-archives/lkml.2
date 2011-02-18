Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab1BRB36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:29:58 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9237 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab1BRB34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:29:56 -0500
X-SpamScore: -29
X-BigFish: VPS-29(zzbb2dK542N1432N98dN9371Pzz1202hzz8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Date: Thu, 17 Feb 2011 18:29:42 -0700
In-Reply-To: <4D5D9A00.7060609@codeaurora.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: AcvO7dIZbdkXd6w4SWi8VBYp4IFeWAAHXHOQ
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com>	<1297872716-13353-2-git-send-email-john.linn@xilinx.com>	<1297872716-13353-3-git-send-email-john.linn@xilinx.com>	<e58673f5-2881-4820-b5cd-99e8ef294ed5@VA3EHSMHS024.ehs.local> <20110217100126.GD22961@pulham.picochip.com> <4D5D9A00.7060609@codeaurora.org>
From: John Linn <John.Linn@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>, Jamie Iles <jamie@jamieiles.com>
CC: <linux@arm.linux.org.uk>, <arnd@arndb.de>, <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, <glikely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 18 Feb 2011 01:29:43.0085 (UTC) FILETIME=[519A55D0:01CBCF0B]
X-RCIS-Action: ALLOW
Message-ID: <8d5eb291-6a7c-4500-92e1-cdd84f4657b9@VA3EHSMHS009.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
> Sent: Thursday, February 17, 2011 2:58 PM
> To: Jamie Iles
> Cc: John Linn; linux@arm.linux.org.uk; arnd@arndb.de;
catalin.marinas@arm.com; linux-
> kernel@vger.kernel.org; glikely@secretlab.ca;
linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and
assembly macros
> 
> On 02/17/2011 02:01 AM, Jamie Iles wrote:
> >> +
> >> +static void putc(char ch)
> >> +{
> >> +	/*
> >> +	 * Wait for room in the FIFO, then write the char into the FIFO
> >> +	 */
> >> +	while (UART_STATUS(LL_UART_PADDR) & UART_SR_TXFULL)
> >> +		;
> >
> > It might be worth adding a barrier() call to these loops to be
explicit
> > about the volatility.
> 
> I think you want cpu_relax() then.

Thanks Stephen.

> 
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


