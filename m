Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab2CIVzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:55:22 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:30664 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809Ab2CIVzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:55:16 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275bh8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: KY Srinivasan <kys@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/2] net/hyperv: Fix data corruption in
 rndis_filter_receive()
Thread-Topic: [PATCH 1/2] net/hyperv: Fix data corruption in
 rndis_filter_receive()
Thread-Index: AQHM/jqPUZwfx7AJlkugqnN6uP2fnJZigRSAgAAAePA=
Date: Fri, 9 Mar 2012 21:55:09 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DCE2A20@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1331328437-26852-1-git-send-email-haiyangz@microsoft.com>
 <20120309.135123.2098113809216101768.davem@davemloft.net>
In-Reply-To: <20120309.135123.2098113809216101768.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, March 09, 2012 4:51 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/2] net/hyperv: Fix data corruption in
> rndis_filter_receive()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Fri,  9 Mar 2012 13:27:16 -0800
> 
> > Limiting the memcpy to be the sizeof(struct rndis_message) can
> > truncate the message if there are Per-Packet-Info or Out-of-Band data.
> >
> > In my earlier patch (commit 45326342), the unnecessary kmap_atomic and
> > kunmap_atomic surrounding this memcpy have been removed because the
> > memory in the receive buffer is always mapped. This memcpy is not
> > necessary either. To fix the bug, I removed the memcpy.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Well, where the heck is patch 2/2?

It's still in the mail server's send queue. This happens sometimes on our mail server.
But it should reach you in half hour or so...

- Haiyang

