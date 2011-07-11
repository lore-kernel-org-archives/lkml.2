Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab1GKOFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:05:05 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:37514
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757515Ab1GKOFD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:05:03 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1447R1432Nzz1202hzz8275bhz2fh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Edwin van Vliet <edwin@cheatah.nl>,
        "roland@kernel.org" <roland@kernel.org>
CC: Mitko Haralanov <mitko.haralanov@qlogic.com>,
        Ralph Campbell <ralph.campbell@qlogic.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jul 2011 07:04:56 -0700
Subject: RE: [PATCH] drivers/infiniband/hw/qib/qib_iba7322: remove double
 define
Thread-Topic: [PATCH] drivers/infiniband/hw/qib/qib_iba7322: remove double
 define
Thread-Index: Acw/TJjvNjRF0r0DTpqvaNGe++OPEgAhsLbQ
Message-ID: <35AAF1E4A771E142979F27B51793A4888838FEEF94@AVEXMB1.qlogic.org>
References: <1310334587-26731-1-git-send-email-edwin@cheatah.nl>
In-Reply-To: <1310334587-26731-1-git-send-email-edwin@cheatah.nl>
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

>
> Double define removed.
>
> Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
> ---
>  drivers/infiniband/hw/qib/qib_iba7322.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

