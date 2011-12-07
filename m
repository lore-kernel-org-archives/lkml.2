Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1LGCwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:52:41 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16192
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754030Ab1LGCwi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:52:38 -0500
X-SpamScore: -11
X-BigFish: VS-11(zz542M1432Nzz1202hzzz2dh2a8h668h839h8e2h8e3h945h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sun york-R58495 <R58495@freescale.com>,
        Durai Kumar-R34055 <r34055@freescale.com>,
        Huang Changming-R66093 <r66093@freescale.com>
Subject: RE: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Topic: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Index: AQHMpIUnsb9+I0lR9k+0uRq1j4EoUpWwJ/0AgAAFb4CAAAQAAIAAAwAAgAAOBACAAAE+gIAAAP2AgB+Fq4A=
Date: Wed, 7 Dec 2011 02:52:36 +0000
Message-ID: <3C06C26914DACA4BB3A368F78CA0B3A7134583@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	<CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	<E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	<ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	<1321464509.7847.41.camel@oslab-l1>
	<1321464968.2309.384.camel@groeck-laptop>
	<1321466135.7847.55.camel@oslab-l1>
	<20111116190954.67c846fc@endymion.delvare>
	<1321467638.7847.73.camel@oslab-l1>
	<20111116201048.4b7877dd@endymion.delvare>
	<1321470915.7847.122.camel@oslab-l1>
 <20111116201847.6b11dc7f@endymion.delvare>
In-Reply-To: <20111116201847.6b11dc7f@endymion.delvare>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.75]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean Delvare,

We agree to apply this patch. Do you have any concerns?
Although Guenter said that he give up, I don't think he really meant it.
Also it is improper if I repost similar patch.
I tested this patch, it works.

Regards,
Yuantian

> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: 2011年11月17日 3:19
> To: sun york-R58495
> Cc: guenter.roeck@ericsson.com; Tabi Timur-B04825; linux-
> i2c@vger.kernel.org; linux-kernel@vger.kernel.org; Tang Yuantian-B29983
> Subject: Re: [PATCH] i2c/busses: (mpc) Add support for
> SMBUS_READ_BLOCK_DATA
> Really, please. I understand you're only trying to help and understand
> the patch, but at some point, if you have zero knowledge about the topic,
> you're not the right person to review the patch, period. You are still
> welcome to test the patch if you can and want, that's a completely
> different task.
> 
> --
> Jean Delvare


