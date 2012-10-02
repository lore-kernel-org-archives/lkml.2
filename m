Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2JBCH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:07:56 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:46544
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533Ab2JBCHz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:07:55 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I4015Izz1202h1d1ah1d2ahzz8275dhz2fh2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net,1/3] hyperv: Fix the max_xfer_size in RNDIS
 initialization
Thread-Topic: [PATCH net,1/3] hyperv: Fix the max_xfer_size in RNDIS
 initialization
Thread-Index: AQHNoCHNYIeOiaYRb0KwMcWHHnpO4ZelCuyAgAA5Y18=
Date: Tue, 2 Oct 2012 02:07:44 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DE315E5@TK5EX14MBXC221.redmond.corp.microsoft.com>
References: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>,<20121001.183919.1364005468105446885.davem@davemloft.net>
In-Reply-To: <20121001.183919.1364005468105446885.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

________________________________________
> From: David Miller [davem@davemloft.net]
> Sent: Monday, October 01, 2012 6:39 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH net,1/3] hyperv: Fix the max_xfer_size in RNDIS initialization

> These patches do not apply cleanly to the current net-next tree
> which is the only place where patches should be targetted right
> now.

I will rebase the patch set to the net-next tree soon.

Thanks,
- Haiyang
