Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1K3TO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:14:28 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:48299
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab1K3TOZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:14:25 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371K542M1432N4015Lzz1202hzz8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: KY Srinivasan <kys@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/2] net/hyperv: Fix long lines in netvsc.c
Thread-Topic: [PATCH 1/2] net/hyperv: Fix long lines in netvsc.c
Thread-Index: AQHMr3NzcWGU3gXrqE6xW+ffQ4hLp5XGNGAA//+TszA=
Date: Wed, 30 Nov 2011 19:13:49 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0CCD01B1@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1322666348-6554-1-git-send-email-haiyangz@microsoft.com>
 <20111130.123626.308237192773284976.davem@davemloft.net>
In-Reply-To: <20111130.123626.308237192773284976.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.75]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, November 30, 2011 12:36 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; gregkh@suse.de; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/2] net/hyperv: Fix long lines in netvsc.c
> 
> 
> Well, since Greg's tree is where the staging move happened, he'll have
> to take any patches to this driver that happen now, rather than me.

Sounds good. And, these patches were sent to devel@linuxdriverproject.org
too.

Greg, could you consider these patches for your tree?

Thanks,
- Haiyang


