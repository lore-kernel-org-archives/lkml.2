Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1EaVVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:21:44 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:57024
	"EHLO CH1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932542Ab1EaVVn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:21:43 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1447R1432Nzz1202hzz8275bhz2ei2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: "roland@kernel.org" <roland@kernel.org>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ralph Campbell <ralph.campbell@qlogic.com>
Date: Tue, 31 May 2011 14:21:32 -0700
Subject: RE: [PATCH] infiniband, qib: convert old cpumask api into new one.
Thread-Topic: [PATCH] infiniband, qib: convert old cpumask api into new one.
Thread-Index: AcwVwR0fWt6erITHTgCXHjIPlGcvyAKF4Oag
Message-ID: <35AAF1E4A771E142979F27B51793A4888838CD0EE3@AVEXMB1.qlogic.org>
References: <4DD46D39.3060408@jp.fujitsu.com>
In-Reply-To: <4DD46D39.3060408@jp.fujitsu.com>
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
> Adapt new APIs. we plan to remove old one later and plan to
> change current->cpus_allowed implementation.
>
> No functional change.

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

