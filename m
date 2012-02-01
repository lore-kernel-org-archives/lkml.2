Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2BATje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:39:34 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:34878
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754892Ab2BATjc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:39:32 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371I542M1432N4015Lzz1202hzz8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: KY Srinivasan <kys@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/5] net/hyperv: Convert camel cased variables in
 rndis_filter.c to lower cases
Thread-Topic: [PATCH 1/5] net/hyperv: Convert camel cased variables in
 rndis_filter.c to lower cases
Thread-Index: AQHM32xz0BJnL5TpUkiK3VcqhdPMWZYo+PiA//96cHA=
Date: Wed, 1 Feb 2012 19:39:21 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0CD2192F@TK5EX14MBXC221.redmond.corp.microsoft.com>
References: <1327941218-12547-1-git-send-email-haiyangz@microsoft.com>
 <20120201.143655.1013171439305457146.davem@davemloft.net>
In-Reply-To: <20120201.143655.1013171439305457146.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.73]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, February 01, 2012 2:37 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/5] net/hyperv: Convert camel cased variables in
> rndis_filter.c to lower cases
> 
> 
> Please do not mix cleanups with real bug fixes.
> 
> Patches #4 and #5 in this series fix real bugs, so you should submit them
> seperately for inclusion to my 'net' tree.
> 
> Once those fixes have propagated to my 'net-next' tree, you can then
> submit
> the cleanups.

Will do.

Thanks,
- Haiyang

