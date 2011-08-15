Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab1HOAXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 20:23:16 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:50848
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937Ab1HOAXP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 20:23:15 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [GIT PATCH] TTY/serial driver patches for 3.1
Thread-Topic: [GIT PATCH] TTY/serial driver patches for 3.1
Thread-Index: AQHMS6VtbctqBOlBPEy1w7LMSdttZZT/4gyAgB2dgAA=
Date: Mon, 15 Aug 2011 00:23:11 +0000
Message-ID: <4E4866EE.3070803@freescale.com>
References: <20110726050225.GA2529@kroah.com>
 <CAOZdJXWuRLSZVof1q51yTmk1FXFR28mb9qSYcbChC8KC2awn=g@mail.gmail.com>
 <20110727040755.GA11308@suse.de>
In-Reply-To: <20110727040755.GA11308@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0)
 Gecko/20110706 Firefox/5.0 SeaMonkey/2.2
x-originating-ip: [24.47.220.27]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <0C0E36775C879942AA29DA6894AEF95D@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> >  I hate to be a pest, but you didn't include my patch, "[v3]
>> >  tty/powerpc: introduce the ePAPR embedded hypervisor byte channel
>> >  driver".  The other six patches of that patchset are already in Linus'
>> >  tree, so I'd really like to get this one into 3.1 as well.  You even
>> >  tried to apply v2 to tty-next about three weeks ago, but it didn't
>> >  apply so I immediately posted v3.

> It is in my queue to review after -rc1 is out.

3.1-rc2 was just released, and I still don't see my driver.  For -rc3, 
Linus said he wants to see only "real fixes" 
(http://lkml.org/lkml/2011/8/14/281).
