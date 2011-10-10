Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1JJS6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:58:02 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34896 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1JJS6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:58:00 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz9371K542M1432N98dKzz1202hzz8275chz2fh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Roland Dreier <roland@purestorage.com>,
        Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dept_Infinipath <Dept_Infinipath@qlogic.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 10 Oct 2011 11:57:55 -0700
Subject: RE: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Thread-Topic: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Thread-Index: AcyFNx+u4c6FJ9RFTYyHOoEvKAmngwCRzqjA
Message-ID: <35AAF1E4A771E142979F27B51793A48888433C0838@AVEXMB1.qlogic.org>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F683D.9020604@xenotime.net>
 <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
In-Reply-To: <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As do I.

I've confirmed that patch does no harm, but I would like to see the error.

Which of the github repos exposes the error?

Mike

> -----Original Message-----
> From: Roland Dreier [mailto:roland@purestorage.com]
> Sent: Friday, October 07, 2011 5:21 PM
> To: Randy Dunlap
> Cc: Stephen Rothwell; linux-next@vger.kernel.org; linux-kernel;
> Dept_Infinipath; linux-rdma@vger.kernel.org; Andrew Morton
> Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build
> errors
>
> On Fri, Oct 7, 2011 at 1:59 PM, Randy Dunlap <rdunlap@xenotime.net>
> wrote:
> > Add <linux/stat.h> to fix build errors:
>
> When did this break?  I build ipath in my test config all the time...
>
>  - R.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

