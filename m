Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab1I2U6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:58:31 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49774 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1I2U6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:58:30 -0400
Date: Thu, 29 Sep 2011 22:57:48 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
Message-ID: <20110929205748.GX19004@ics.muni.cz>
References: <20110721132627.GY7561@ics.muni.cz>
 <4E291F28.2040609@ct.jp.nec.com>
 <20110722081903.GB7561@ics.muni.cz>
 <4E2A7806.1060601@ce.jp.nec.com>
 <20110724221619.GM16487@ics.muni.cz>
 <4E367256.8020206@ct.jp.nec.com>
 <20110908132756.GT31717@ics.muni.cz>
 <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com>
 <20110916140839.GE7428@ics.muni.cz>
 <4E76D810.6010504@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E76D810.6010504@ce.jp.nec.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 94.112.253.31
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 29 Sep 2011 22:58:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 02:50:08PM +0900, Jun'ichi Nomura wrote:
>   2.6.32.36
>     no-multipath:        2.8 GB/s
>     multipath:           600 MB/s
>     multipath w/ patch:  2.8-2.9 GB/s
> 
>   3.0.3
>     no-multipath:        ??
>     multipath:           2.5 GB/s
>     multipath w/ patch:  2.5 GB/s(?)
> 
> Have you tried 3.0.3 without multipath?

yes, 3GB/s and only kwapd0 and kswapd1 is running, no kworker or ksoftirqd..
 
> > top looks like this:
> >    63 root      20   0     0    0    0 S   38  0.0   0:16.65 kswapd1
> >    18 root      20   0     0    0    0 R   32  0.0   0:14.38 kworker/4:0
> >    19 root      20   0     0    0    0 R   30  0.0   0:20.88 ksoftirqd/4
> >   153 root      20   0     0    0    0 R   29  0.0   0:14.46 kworker/4:2
> >    62 root      20   0     0    0    0 S   22  0.0   0:09.44 kswapd0
> 
> dm-multipath itself does not use workqueue for normal I/Os.
> So you might be hitting a different problem.

-- 
Luká¹ Hejtmánek
