Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2HETdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 15:33:01 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:6379
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278Ab2HETc7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 15:32:59 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz9371I542M1432I4015Izz1202hzz8275bh8275dhz2fh2a8h668h839h944hd25hf0ah107ah)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,1/1] hyperv: Move wait completion msg code into
 rndis_filter_halt_device()
Thread-Topic: [PATCH net-next,1/1] hyperv: Move wait completion msg code
 into rndis_filter_halt_device()
Thread-Index: AQHNcayHH4iOtCIeC0ygWD5+byiR55dIwqcAgALXdUA=
Date: Sun, 5 Aug 2012 19:16:32 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DDFAEF4@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1344022338-3010-1-git-send-email-haiyangz@microsoft.com>
 <20120803.165212.106382119661240198.davem@davemloft.net>
In-Reply-To: <20120803.165212.106382119661240198.davem@davemloft.net>
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
> Sent: Friday, August 03, 2012 7:52 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,1/1] hyperv: Move wait completion msg code
> into rndis_filter_halt_device()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Fri,  3 Aug 2012 12:32:18 -0700
> 
> > We need to wait for send_completion msg before put_rndis_request() at
> > the end of rndis_filter_halt_device(). Otherwise,
> > netvsc_send_completion() may reference freed memory which is
> overwritten, and cause panic.
> >
> > Reported-by: Long Li <longli@microsoft.com>
> > Reported-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> This is a bug fix, so applied to 'net'.  Please target your patches properly.
> 
> Don't just be afraid that I'll reject the patch if you target it at 'net', and
> therefore just target everything at 'net-next'.  That is certainly worse.

I see. 

Thanks,
- Haiyang

