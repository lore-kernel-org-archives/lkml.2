Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1KOClm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:41:42 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:57872
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab1KOCll convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:41:41 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Topic: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Index: AQHMnzxH0OGSlOlhpUqJwhasviAu1JWmh/EAgAAmwwCAAAOUgIAABsaAgACBiACAAEODAIAGJtsAgAABVQA=
Date: Tue, 15 Nov 2011 02:41:35 +0000
Message-ID: <4EC1D15E.3010800@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
 <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
 <C0DED343-76A8-457E-BF54-E52DFCAC83A8@boeing.com>
 <58FDDDA5-26C4-493B-A00D-81DD94A5C26A@kernel.crashing.org>
 <20111110165455.GE11983@schlenkerla.am.freescale.net>
 <15AB1C61-181F-4454-AF99-772B73DE0AA5@boeing.com>
 <1320986410.21206.48.camel@pasglop>
 <4A0007C2-1C2C-4162-98E8-ACCA4E673AFE@boeing.com>
In-Reply-To: <4A0007C2-1C2C-4162-98E8-ACCA4E673AFE@boeing.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1)
 Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <868C99E55710EC428A74EF1281ED9579@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moffett, Kyle D wrote:
>the PPC Book-E spec documents that the pagesize is an even multiple
> of the cacheline size and the cachelines are always page-aligned.

cachelines are page aligned?

-- 
Timur Tabi
Linux kernel developer at Freescale
