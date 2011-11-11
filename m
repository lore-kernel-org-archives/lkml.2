Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab1KKQjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:39:40 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:26164 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757239Ab1KKQjj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:39:39 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>
CC: Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Topic: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Index: AQHMoJB2KAiKIl6KR0iOAe8H9Sg5Bg==
Date: Fri, 11 Nov 2011 16:39:21 +0000
Message-ID: <4EBD4FB8.2020406@freescale.com>
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
In-Reply-To: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1)
 Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DCE347E91E35C84C9EA1E8984A4045DF@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kokoris, Ioannis wrote:
> Hi,
>
> QE Microcode Initialization using qe_upload_microcode() does not work
> on P1021 if the IRAM-Ready register is not set after the microcode
> upload. This patch adds a definition for the "I-RAM Ready" register and
> sets it uppon microcode upload completion.

Will this code still work on other QE parts, like the MPC8323?

-- 
Timur Tabi
Linux kernel developer at Freescale
