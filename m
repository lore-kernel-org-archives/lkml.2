Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab2CGT6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:58:11 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:31124
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932760Ab2CGT6I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:58:08 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371I542M1432N98dK4015Izz1202hzz8275bhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Olaf Hering <olaf@aepfle.de>
Subject: RE: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Thread-Topic: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Thread-Index: AQHM/JSG1nuVKL/c60qAlPTf0dg/p5ZfNf4AgAAJjqA=
Date: Wed, 7 Mar 2012 19:57:53 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DCD4CA3@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
 <20120307192204.GA9163@kroah.com>
In-Reply-To: <20120307192204.GA9163@kroah.com>
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
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, March 07, 2012 2:22 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; Olaf Hering
> Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
> driver name
> 
> On Wed, Mar 07, 2012 at 11:05:31AM -0800, Haiyang Zhang wrote:
> > From: Olaf Hering <olaf@aepfle.de>
> >
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> > index 0ae7a1a..53d1ee5 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -40,6 +40,8 @@
> >
> >  #include "hyperv_net.h"
> >
> > +#define MODULE_NAME "hv_netvsc"
> 
> No, please use the built-in macro for this and don't define your own,
> that's totally redundant.

I have submitted a patch using the built-in KBUILD_MODNAME.
Thanks,
- Haiyang

