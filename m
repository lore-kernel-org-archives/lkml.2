Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919Ab2FDQUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:20:31 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:7828 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab2FDQU3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:20:29 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zz9371I542M1432N4015Izz1202hzz8275bh8275dhz2fh2a8h668h839h944hd25hf0ah)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 0/1] net/hyperv: Use wait_event on outstanding sends
 during device removal
Thread-Topic: [PATCH 0/1] net/hyperv: Use wait_event on outstanding sends
 during device removal
Thread-Index: AQHNQmlT3T3tfMxvGESLRkeB5KLf4pbqTvCAgAAGaTA=
Date: Mon, 4 Jun 2012 16:20:19 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DD6F82A@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1338820532-2345-1-git-send-email-haiyangz@microsoft.com>
 <20120604.115119.568655178193939719.davem@davemloft.net>
In-Reply-To: <20120604.115119.568655178193939719.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.70]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, June 04, 2012 11:51 AM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 0/1] net/hyperv: Use wait_event on outstanding sends
> during device removal
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon,  4 Jun 2012 07:35:31 -0700
> 
> > This patch is targeting net-next tree (when it's available for check
> in).
> >
> > Haiyang Zhang (1):
> >   net/hyperv: Use wait_event on outstanding sends during device
> removal
> 
> Why in the world are you doing this?
> 
> This patch you are already asking me to apply to the 'net' tree, and
> changes already will automatically propagate from 'net' to
> 'net-next' the next time I merge those trees.
> 
> So you never need to submit bug fixes twice, once for 'net' and
> once for 'net-next' so please do not do it.

A while ago, I was told the 'net' tree is only for urgent fixes, and I
should specify the target tree instead of letting you guess. But, that's
fine if you will apply it (after my updating the indentation) to 'net',
then merge it into 'net-next' tree automatically.

Thanks,
- Haiyang


