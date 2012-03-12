Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2CLTwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:52:35 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:20890
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876Ab2CLTwd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:52:33 -0400
X-SpamScore: -18
X-BigFish: VS-18(zz9371I1447M542M1432N4015Izz1202hzz8275bh8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
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
Thread-Index: AQHM/jqPUZwfx7AJlkugqnN6uP2fnJZltnOAgAEVsrCAAEpNAIAAAD5w
Date: Mon, 12 Mar 2012 19:52:20 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DCE4276@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1331328437-26852-1-git-send-email-haiyangz@microsoft.com>
	<20120311.155111.1595145426893784653.davem@davemloft.net>
	<A1F3067C9B68744AA19F6802BAB8FFDC0DCE4044@TK5EX14MBXC223.redmond.corp.microsoft.com>
 <20120312.125102.65764809953128692.davem@davemloft.net>
In-Reply-To: <20120312.125102.65764809953128692.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, March 12, 2012 3:51 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/2] net/hyperv: Fix data corruption in
> rndis_filter_receive()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon, 12 Mar 2012 15:39:02 +0000
> 
> > And, thanks for the reminder, I will specify the target tree in future
> submissions.
> 
> You still have to formally resubmit these patches, with the proper indication
> of where the patches go.  Just replying to my complaint with an answer
> won't make your patches get replied, as I've completely dropped this
> submission.

Sure, I'm re-submitting them right now.

Thanks,
- Haiyang

