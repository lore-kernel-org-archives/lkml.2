Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1DTCFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:05:22 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:23589
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812Ab1DTCFU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:05:20 -0400
X-SpamScore: -43
X-BigFish: VPS-43(z21eRz936eK9371O1447R542M1432N98dKzz1202hzz8275bhz2ei2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Madhu Iyengar <madhu.iyengar@qlogic.com>
To: James Bottomley <James.Bottomley@suse.de>, Andi Kleen <ak@linux.intel.com>
CC: =?iso-8859-9?Q?Ozan_=C7a=F0layan?= <ozan@pardus.org.tr>,
        stable <stable@kernel.org>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Tue, 19 Apr 2011 19:05:15 -0700
Subject: RE: [BISECTED] QLogic Corp. ISP2532-based 8Gb Fibre Channel not
 working on 2.6.35.y
Thread-Topic: [BISECTED] QLogic Corp. ISP2532-based 8Gb Fibre Channel not
 working on 2.6.35.y
Thread-Index: Acv+s9FaXUSzzfjpRKqKY9/9t2/ZkQASx6hg
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A9D52F7@AVEXMB1.qlogic.org>
References: <4DAD5495.5060704@pardus.org.tr>
	 <20110419165801.GA17788@tassilo.jf.intel.com>
 <1303232648.3171.22.camel@mulgrave.site>
In-Reply-To: <1303232648.3171.22.camel@mulgrave.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de]
> Sent: Tuesday, April 19, 2011 10:04 AM
> To: Andi Kleen
> Cc: Ozan Çaðlayan; stable; Giridhar Malavali; linux-kernel; Andrew Vasquez
> Subject: Re: [BISECTED] QLogic Corp. ISP2532-based 8Gb Fibre Channel not
> working on 2.6.35.y
>
> On Tue, 2011-04-19 at 09:58 -0700, Andi Kleen wrote:
> > > From 2f0f3f4f06f7cfadebf58b70bd9e7f71d8fd96e4 Mon Sep 17 00:00:00 2001
> > > From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>
> > > Date: Fri, 23 Jul 2010 15:28:24 +0500
> > > Subject: [PATCH 021/107] [SCSI] qla2xxx: Appropriately log FCP
> > > priority data messages
> > >
> > > Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> > > Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> > >
> > >
> > > -------
> > >
> > > So I think at least the first commit that I've mentioned should be
> > > queued for the next 2.6.35.y to fix this issue.
> >
> > Thanks for the bisection.
> >
> > Can I get an ack for that from the driver or SCSI maintainer or
> > patch author first please?
> > I don't understand the driver well enough to make a call myself.
>
> I'll defer to qlogic ... it looks like a driver enhancement to add FCP
> prioritised queues ... but it would be a bug fix, I suppose, if the card
> can't actually operate without this.
>
> James
>
>

For the qla2xxx patch above, here's the ack:
Acked-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

