Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2B2TZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:25:18 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52076 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758286Ab2B2TZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:25:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>, Kalle Valo <kvalo@qca.qualcomm.com>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "John W. Linville" <linville@tuxdriver.com>, Ilan Elias <ilane@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 29 Feb 2012 11:22:36 -0800
Subject: RE: coding style issues -- [davem@davemloft.net: Re: pull request:
 wireless-next 2012-02-06]
Thread-Topic: coding style issues -- [davem@davemloft.net: Re: pull request:
 wireless-next 2012-02-06]
Thread-Index: Acz3Fj3oFF8uTcWmSR+1ZzNO3BsX7AAAGoNA
Message-ID: <477F20668A386D41ADCC57781B1F70430836762D6C@SC-VEXCH1.marvell.com>
References: <20120229173421.GA13733@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430836762D55@SC-VEXCH1.marvell.com>
 <1330542811.21491.7.camel@joe2Laptop>
In-Reply-To: <1330542811.21491.7.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1TJPPY9004519

Hi Joe,

> Subject: RE: coding style issues -- [davem@davemloft.net: Re: pull request: wireless-next 2012-02-06]
> 
> On Wed, 2012-02-29 at 10:57 -0800, Bing Zhao wrote:
> > Joe Perches submitted a patch "[PATCH v2] checkpatch: Add some --strict coding style checks"
> > I have applied Joe's patch to my local git tree.
> >
> > All new patches will follow Dave's rules and be checked with --strict option.
> > Furthermore, we will have a series of cleanup patches to address the coding style issues in
> existing code.
> 
> Hi Bing.
> 
> There's an issue with the checkpatch patch.
> It doesn't always work correctly when there
> are consecutive parenthesis.
> 
> Kalle Valo showed an example that fails:
> 
> 	if (!IS_ALIGNED((unsigned long) skb->data - HTC_HDR_LENGTH, 4) &&
> 	    skb_cloned(skb)) {

Thanks for letting us know.

> 
> I have a tentative fix here, but I'm waiting on
> Andy Whitcroft to give some guidance on how best
> to fix it given a minimum perl version of 5.10.

I have "Perl v5.10.0 built for x86_64-linux-gnu-thread-multi" on my system.
I guess it should be fine.

Thanks,
Bing

> 
> The proposed patch doesn't work with perl versions
> less than 5.10 and there is at least one person
> that still uses 5.8.
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
