Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2ISEvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:51:38 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:43615
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080Ab2ISEvf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:51:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdhbe9i1155h)
From: Xie Shaohui-B21989 <B21989@freescale.com>
To: Shaun Ruffell <sruffell@digium.com>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "avorontsov@mvista.com" <avorontsov@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH] edac/85xx: fix error handle of mpc85xx_mc_err_probe
Thread-Topic: [PATCH] edac/85xx: fix error handle of mpc85xx_mc_err_probe
Thread-Index: AQHNkaMM7ec3MtYj5keBzMlX2iUaRpeKfBmAgAPeSnCAAv0rAP//tk/wgABXOwD//7wDMA==
Date: Wed, 19 Sep 2012 04:51:30 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C9079E4003@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1347533729-5893-1-git-send-email-Shaohui.Xie@freescale.com>
 <20120914182137.GD18672@digium.com>
 <ED492CCEAF882048BC2237DE806547C9079E171E@039-SN2MPN1-012.039d.mgd.msft.net>
 <20120919030438.GE24873@digium.com>
 <ED492CCEAF882048BC2237DE806547C9079E3F3D@039-SN2MPN1-012.039d.mgd.msft.net>
 <20120919035306.GF24873@digium.com>
In-Reply-To: <20120919035306.GF24873@digium.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Shaun Ruffell [mailto:sruffell@digium.com]
> Sent: Wednesday, September 19, 2012 11:53 AM
> To: Xie Shaohui-B21989
> Cc: linux-edac@vger.kernel.org; linuxppc-dev@lists.ozlabs.org;
> akpm@linux-foundation.org; avorontsov@mvista.com; linux-
> kernel@vger.kernel.org; grant.likely@secretlab.ca
> Subject: Re: [PATCH] edac/85xx: fix error handle of mpc85xx_mc_err_probe
> 
> On Wed, Sep 19, 2012 at 03:43:35AM +0000, Xie Shaohui-B21989 wrote:
> > > On Mon, Sep 17, 2012 at 10:32:59AM +0000, Xie Shaohui-B21989 wrote:
> > > >
> > > > BTW: seems you are using a different kernel tree with mine.
> > >
> > > On the chance that I missing something important: Why do you say I
> > > was running a different kernel tree? I was against 3.6-rc2 when I
> > > original hit the problem.
> >
> > [S.H] I'm using 3.6-rc4, and some codes in your patch I did not find
> > them in 3.6-rc4.
> 
> Is it because there were three patches in the series?
> 
>   [1/3] https://lkml.org/lkml/2012/9/14/473
>   [2/3] https://lkml.org/lkml/2012/9/14/469
>   [3/3] https://lkml.org/lkml/2012/9/14/474
> 
> They are also the last three commits on my edac_debug_v2 branch here,
> which is on top of 3.6-rc6:
> 
> https://github.com/sruffell/linux/commits/edac_debug_v2/

[S.H] Yes.

Best Regards, 
Shaohui Xie

