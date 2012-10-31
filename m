Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946015Ab2JaSSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:18:54 -0400
Received: from mx2.netapp.com ([216.240.18.37]:7253 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945973Ab2JaSSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:18:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344236400"; 
   d="scan'208";a="705777276"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "skinsbursky@parallels.com" <skinsbursky@parallels.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baggins@pld-linux.org" <baggins@pld-linux.org>,
        "arekm@pld-linux.org" <arekm@pld-linux.org>
Subject: RE: [PATCH] lockd: fix races in per-net NSM client handling
Thread-Topic: [PATCH] lockd: fix races in per-net NSM client handling
Thread-Index: AQHNt40RdLsdoUV8xka8P1/P/7sFb5fUJnkAgAADr4D//44/UA==
Date: Wed, 31 Oct 2012 18:18:48 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90929FCC1@SACEXCMBX04-PRD.hq.netapp.com>
References: <1689813.hptKgzjpAu@localhost>
 <20121031174946.GA13591@kroah.com> <4005626.trvd4a4buj@localhost>
In-Reply-To: <4005626.trvd4a4buj@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9VIIvfN020887

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Pawel Sikora
> Sent: Wednesday, October 31, 2012 2:03 PM
> To: Greg KH
> Cc: skinsbursky@parallels.com; stable@vger.kernel.org; linux-
> kernel@vger.kernel.org; baggins@pld-linux.org; arekm@pld-linux.org
> Subject: Re: [PATCH] lockd: fix races in per-net NSM client handling
> 
> On Wednesday 31 of October 2012 10:49:46 Greg KH wrote:
> > On Wed, Oct 31, 2012 at 06:27:36PM +0100, PaweÅ‚ Sikora wrote:
> > > Hi,
> > >
> > > the patch metioned in https://lkml.org/lkml/2012/10/24/175 seems to
> > > fix the 3.6.3 oops (while 3.6.2 works fine) at 16-cores opteron server.
> > > please queue this path for 3.6.$next.
> >
> > Is it in Linus's tree already?  If so, what is the git commit id?
> 
> the mainstream contains some lock deamon fixes already:
> 
> * e498daa LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero
> * a4ee8d9 LOCKD: fix races in nsm_client_get
> 
> but i don't know where is the right fix. Stanislav, could you put some light on
> this?

The above 2 patches (which are already in 3.6.5) replace Stanislav's patch, which will not be merged upstream.

Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
