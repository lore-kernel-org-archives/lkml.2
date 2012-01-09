Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2AIQwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:52:40 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:55665
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932534Ab2AIQuK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:50:10 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zz1447M1432Nzz1202hzz8275bhz2ei2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Dept_Infinipath <Dept_Infinipath@qlogic.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 9 Jan 2012 08:49:56 -0800
Subject: RE: [PATCH 1/4] drivers/infiniband/hw/qib/qib_iba6120.c: convert
 GFP_KERNEL to GFP_ATOMIC
Thread-Topic: [PATCH 1/4] drivers/infiniband/hw/qib/qib_iba6120.c: convert
 GFP_KERNEL to GFP_ATOMIC
Thread-Index: AczOss0l6AJLKoBzSPeCMTL7dgUNvwAO9Cgg
Message-ID: <35AAF1E4A771E142979F27B51793A4888885970586@AVEXMB1.qlogic.org>
References: <1326102050-30265-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1326102050-30265-1-git-send-email-Julia.Lawall@lip6.fr>
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


> Subject: [PATCH 1/4] drivers/infiniband/hw/qib/qib_iba6120.c: convert
> GFP_KERNEL to GFP_ATOMIC
>
> From: Julia Lawall <julia.lawall@lip6.fr>
>
> The function is called with locks held and thus should not use
> GFP_KERNEL.
>
> The semantic patch that makes this report is available
> in scripts/coccinelle/locks/call_kern.cocci.
>
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
>
> Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

