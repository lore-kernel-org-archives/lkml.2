Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2IZNVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:21:02 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:55111 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756336Ab2IZNVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:21:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zz9371I542M1432Id6f1izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAYL2T-01-L6A-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Andres Freund <andres@anarazel.de>, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Topic: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Index: AQHNlMf4cJj+N2GqCk+osvT7J0ZY3JeOgYkggABg+QD//7NwcIAAhHWA//+4SPCADiVJgP//scdw
Date: Wed, 26 Sep 2012 13:20:52 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02C435757@sausexdag03.amd.com>
References: <201209171329.15699.andres@anarazel.de>
 <201209171555.43008.andres@anarazel.de>
 <A3397C8B8B789E45844E7EC5DEAD89D02C4333B6@sausexdag03.amd.com>
 <201209171915.45267.andres@anarazel.de>
 <A3397C8B8B789E45844E7EC5DEAD89D02C433574@sausexdag03.amd.com>
 <20120926130009.GE28937@mwanda>
In-Reply-To: <20120926130009.GE28937@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.13.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Wednesday, September 26, 2012 9:00 AM
> To: Deucher, Alexander
> Cc: Andres Freund; LKML; David Airlie; dri-devel@lists.freedesktop.org
> Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
> allocate a PPLL
> 
> This is fixed now?

It should be.  The patch was reverted for 3.6.

Alex

> 
> regards,
> dan carpenter


