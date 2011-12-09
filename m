Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1LIQtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:49:31 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:4114
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab1LIQt3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:49:29 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
Thread-Topic: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
Thread-Index: AQHMsSx+2SVgzLNkXk+4T3Hv4pSSBZXTs8WwgACRBAD//305YA==
Date: Fri, 9 Dec 2011 16:49:17 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0CCD461C@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1322855785-22776-1-git-send-email-haiyangz@microsoft.com>
 <A1F3067C9B68744AA19F6802BAB8FFDC0CCD457B@TK5EX14MBXC227.redmond.corp.microsoft.com>
 <20111209163508.GA19001@suse.de>
In-Reply-To: <20111209163508.GA19001@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, December 09, 2011 11:35 AM
> To: Haiyang Zhang
> Cc: KY Srinivasan; davem@davemloft.net; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
> 
> On Fri, Dec 09, 2011 at 04:00:59PM +0000, Haiyang Zhang wrote:
> > > -----Original Message-----
> > > From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> > >  drivers/net/hyperv/netvsc.c     |   14 +++++++++++---
> > >  drivers/net/hyperv/netvsc_drv.c |   24 +-----------------------
> > >  2 files changed, 12 insertions(+), 26 deletions(-)
> >
> > Hi Greg,
> >
> > Since the netvsc haven't been merged into Dave's tree yet after out of
> staging,
> > could you consider this patch for your tree?
> 
> It's in my "to-apply" queue already.

Thank you!

- Haiyang

