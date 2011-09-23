Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1IWBMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:12:38 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23468 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1IWBMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:12:33 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-console@vger.kernel.org" <linux-console@vger.kernel.org>
Subject: Re: [PATCH] drivers/tty: don't use the byte channel handle as a
 parameter in ehv_bytechan.c
Thread-Topic: [PATCH] drivers/tty: don't use the byte channel handle as a
 parameter in ehv_bytechan.c
Thread-Index: AQHMd8Lik0aBVkYCE0CzfKVTYPu6BZVaXN4A//+uwoCAAFdVAIAAHOYA
Date: Fri, 23 Sep 2011 01:11:55 +0000
Message-ID: <4E7BDCDA.6060506@freescale.com>
References: <1316543217-13769-1-git-send-email-timur@freescale.com>
 <20110922230640.GA16981@kroah.com> <4E7BC1A9.5050708@freescale.com>
 <20110922232828.GA12088@kroah.com>
In-Reply-To: <20110922232828.GA12088@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:6.0.2)
 Gecko/20110902 Firefox/6.0.2 SeaMonkey/2.3.3
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <C5C7C787C50EC349BFDFC774FFB5C123@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>> >  >  This patch doesn't apply at all to my tty tree, what was it made
>>> >  >  against?
>> >
>> >  An internal repository that supposed to be in-sync with the latest and greatest.
>> >
>> >  What's the URL for your tty-next repo?
> There is no public one due to kernel.org being down.
>
> Does your patch apply to linux-next?

It does not, and I see why now.  Looks like the internal tree is not in 
sync after all.

I will post a V2 shortly.

-- 
Timur Tabi
Linux kernel developer at Freescale
