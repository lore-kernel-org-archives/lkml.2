Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1GZPFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:05:25 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:24917
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab1GZPFV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:05:21 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [GIT PATCH] TTY/serial driver patches for 3.1
Thread-Topic: [GIT PATCH] TTY/serial driver patches for 3.1
Thread-Index: AQHMS6VtbctqBOlBPEy1w7LMSdttZQ==
Date: Tue, 26 Jul 2011 15:05:17 +0000
Message-ID: <CAOZdJXWuRLSZVof1q51yTmk1FXFR28mb9qSYcbChC8KC2awn=g@mail.gmail.com>
References: <20110726050225.GA2529@kroah.com>
In-Reply-To: <20110726050225.GA2529@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <375F0D82D6FC7B4CA22FC1855F182442@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 12:02 AM, Greg KH <gregkh@suse.de> wrote:
> Here is the big tty/serial patchset for your 3.1 tree.
>
> Nothing major at all, lots of line discipline tweaks for the newer ones
> that were added last release, and some small tty core fixes as well.

Greg,

I hate to be a pest, but you didn't include my patch, "[v3]
tty/powerpc: introduce the ePAPR embedded hypervisor byte channel
driver".  The other six patches of that patchset are already in Linus'
tree, so I'd really like to get this one into 3.1 as well.  You even
tried to apply v2 to tty-next about three weeks ago, but it didn't
apply so I immediately posted v3.

-- 
Timur Tabi
Linux kernel developer at Freescale
