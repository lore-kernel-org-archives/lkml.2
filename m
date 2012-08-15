Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2HOIAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:00:00 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:31977
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab2HOH76 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 03:59:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Dan Williams <djbw@fb.com>,
        "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: RE: [PATCH v7 0/8] Raid: enable talitos xor offload for improving
 performance
Thread-Topic: [PATCH v7 0/8] Raid: enable talitos xor offload for improving
 performance
Thread-Index: AQHNdge1qBCFxaP1ski951Lb3NNwmpdSCXOAgAb6eMCAARMaAIAAck0w
Date: Wed, 15 Aug 2012 07:59:54 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70E40F1@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1344500375-8457-1-git-send-email-qiang.liu@freescale.com>
	<20120809170307.GG14264@ovro.caltech.edu>
	<BCB48C05FCE8BC4D9E61E841ECBE6DB70E3D47@039-SN2MPN1-013.039d.mgd.msft.net>
 <CAA9_cme4tHrx14JaSaHwgcGq79qQK5bv8E205fbC3ega5OpUiQ@mail.gmail.com>
In-Reply-To: <CAA9_cme4tHrx14JaSaHwgcGq79qQK5bv8E205fbC3ega5OpUiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Wednesday, August 15, 2012 4:02 AM
> To: Liu Qiang-B32616
> Cc: dan.j.williams@intel.com; vinod.koul@intel.com; arnd@arndb.de;
> herbert@gondor.apana.org.au; gregkh@linuxfoundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; linux-
> crypto@vger.kernel.org; Ira W. Snyder
> Subject: Re: [PATCH v7 0/8] Raid: enable talitos xor offload for
> improving performance
> 
> On Tue, Aug 14, 2012 at 2:04 AM, Liu Qiang-B32616 <B32616@freescale.com>
> wrote:
> > Hi Vinod,
> >
> > Would you like to apply this series from patch 2/8 to 7/8) in your tree?
> > The link as below,
> > http://patchwork.ozlabs.org/patch/176023/
> > http://patchwork.ozlabs.org/patch/176024/
> > http://patchwork.ozlabs.org/patch/176025/
> > http://patchwork.ozlabs.org/patch/176026/
> > http://patchwork.ozlabs.org/patch/176027/
> > http://patchwork.ozlabs.org/patch/176028/
> >
> 
> Hi, sorry for the recent silence I've been transitioning and am now
> just catching up.  I'll take a look and then it's fine for these to go
> through Vinod's tree.
Hello Dan,

Please review, this issue has been continued since many years. I hope we can fix
it this time. Thanks.

> 
> --
> Dan


