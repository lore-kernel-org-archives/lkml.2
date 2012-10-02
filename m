Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2JBO2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:28:35 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:20561
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038Ab2JBO2e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:28:34 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I542M1432I4015Izz1202h1d1ah1d2ahzz8275dhz2fh2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net, 3/3] hyperv: Fix page buffer handling in
 rndis_filter_send_request()
Thread-Topic: [PATCH net, 3/3] hyperv: Fix page buffer handling in
 rndis_filter_send_request()
Thread-Index: AQHNoHljbgzgJY0lzkKaM4dpsOAA1pemE0uQ
Date: Tue, 2 Oct 2012 14:28:25 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DE326F6@TK5EX14MBXC221.redmond.corp.microsoft.com>
References: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
 <1349130657-7987-3-git-send-email-haiyangz@microsoft.com>
 <20121002083847.GR4587@mwanda>
In-Reply-To: <20121002083847.GR4587@mwanda>
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
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, October 02, 2012 4:39 AM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net, 3/3] hyperv: Fix page buffer handling in
> rndis_filter_send_request()
> 
> On Mon, Oct 01, 2012 at 03:30:57PM -0700, Haiyang Zhang wrote:
> > Add another page buffer if the request message crossed page boundary.
> >
> 
> What are the user visible effects of this bug fix?  Please put that
> in the commit message.

Will do.

Thanks,
- Haiyang


