Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab1K3AIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:08:51 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:48070
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072Ab1K3AIt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:08:49 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz9371K98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: Li Yang-R58472 <r58472@freescale.com>,
        Shi Xuelin-B29237 <B29237@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Topic: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Thread-Index: AQHMrvQ5ooeCzZcUA0elGysglgicRA==
Date: Wed, 30 Nov 2011 00:08:44 +0000
Message-ID: <CAOZdJXWX9EHfcXTuVag+-MvUvqnA7bA5RjmLx4jE5Cu5JmQdvg@mail.gmail.com>
References: <1321937705-19587-1-git-send-email-b29237@freescale.com>
	<20111122185924.GA23323@ovro.caltech.edu>
	<DBB740589CE8814680DECFE34BE197AB148CDD@039-SN1MPN1-006.039d.mgd.msft.net>
	<20111128163814.GA10919@ovro.caltech.edu>
	<3F607A5180246847A760FD34122A1E052E07B7@039-SN1MPN1-003.039d.mgd.msft.net>
	<20111129172539.GB15331@ovro.caltech.edu>
In-Reply-To: <20111129172539.GB15331@ovro.caltech.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <F9EEEE6510D45C40BCC5CFBCE09B5760@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:25 AM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:

> I believe that you are correct, for powerpc. However, anything outside
> of arch/powerpc shouldn't assume it only runs on powerpc. I wouldn't be
> surprised to see fsldma running on an iMX someday (ARM processor).

I certainly would.  The i.MX chips have their own DMA controller.  The
DMA controller that fsldma.c works with is unique to Freescale's 83xx,
85xx, and QorIQ chips.

-- 
Timur Tabi
Linux kernel developer at Freescale
