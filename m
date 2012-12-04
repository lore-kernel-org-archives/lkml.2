Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2LDM3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:29:39 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:8398
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989Ab2LDM3h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:29:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551biz98dIzz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631hbe9i1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: Re: [PATCH 4/4 v6] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 4/4 v6] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHNz7bIwVXO7Gwzb0qI4toHcJfWV5gHHlqAgAFzFwCAAAUiAA==
Date: Tue, 4 Dec 2012 12:29:29 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B7081C2466@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1354360921-20850-1-git-send-email-Varun.Sethi@freescale.com>
 <50BD056F.7070701@freescale.com>
 <C5ECD7A89D1DC44195F34B25E172658D2B715D@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D2B715D@039-SN2MPN1-013.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0)
 Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
x-originating-ip: [70.112.99.80]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <2324A115B6900642B3AE38FF6D849B9B@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sethi Varun-B16395 wrote:

> This would in any case change with the new LIODN allocation scheme. I
> intend on introducing the new scheme as a separate patch.

At the very least, you should detect when an LIODN is too large and print 
an error message.

-- 
Timur Tabi
Linux kernel developer at Freescale
