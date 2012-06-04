Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923Ab2FDQO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:14:29 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:14303
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055Ab2FDQO1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:14:27 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zz9371I542M1432N4015Izz1202hzz8275bh8275dhz2fh2a8h668h839h944hd25hf0ah)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] net/hyperv: Use wait_event on outstanding sends
 during device removal
Thread-Topic: [PATCH 1/1] net/hyperv: Use wait_event on outstanding sends
 during device removal
Thread-Index: AQHNQmJVGNFOmmtJoUqEkFaeDTXkG5bqThWAgAAG5HA=
Date: Mon, 4 Jun 2012 16:14:12 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DD6F80B@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1338820532-2345-1-git-send-email-haiyangz@microsoft.com>
	<1338820532-2345-2-git-send-email-haiyangz@microsoft.com>
 <20120604.114803.742884170282591530.davem@davemloft.net>
In-Reply-To: <20120604.114803.742884170282591530.davem@davemloft.net>
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
> Sent: Monday, June 04, 2012 11:48 AM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] net/hyperv: Use wait_event on outstanding sends
> during device removal
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon,  4 Jun 2012 07:35:32 -0700
> 
> > +	wait_event(net_device->wait_drain,
> > +		atomic_read(&net_device->num_outstanding_sends) == 0);
> 
> Please indent this properly.  The goal is not to indent using only
> TAB characters, the goal is to line things up to the proper column
> using TAB and space characters as needed.
> 
> You must make the first character on the second line be at the
> first column after the openning parenthesis on the previous line.

Will do.

Thanks,
- Haiyang 

