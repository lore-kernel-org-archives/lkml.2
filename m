Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1JKNGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:06:39 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:4495
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab1JKNGh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:06:37 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1447M1432Nzz1202hzz8275ch8275bhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
X-FB-SS: 13,
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dept_Infinipath <Dept_Infinipath@qlogic.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roland Dreier <roland@purestorage.com>
Date: Tue, 11 Oct 2011 06:06:29 -0700
Subject: RE: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Thread-Topic: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Thread-Index: AcyFNAs0MoRrsv6lSU+esHqfJvocIwC4lnCQ
Message-ID: <35AAF1E4A771E142979F27B51793A48888433C0972@AVEXMB1.qlogic.org>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F683D.9020604@xenotime.net>
In-Reply-To: <4E8F683D.9020604@xenotime.net>
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

> Add <linux/stat.h> to fix build errors:
>
> drivers/infiniband/hw/ipath/ipath_init_chip.c:54:1: error: 'S_IRUGO'
> undeclared here (not in a function)
> drivers/infiniband/hw/ipath/ipath_init_chip.c:54:1: error: bit-field
> '<anonymous>' width not an integer constant
> drivers/infiniband/hw/ipath/ipath_init_chip.c:67:1: error: 'S_IWUSR'
> undeclared here (not in a function)
> drivers/infiniband/hw/ipath/ipath_init_chip.c:67:1: error: bit-field
> '<anonymous>' width not an integer constant
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

