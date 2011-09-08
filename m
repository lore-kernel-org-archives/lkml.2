Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab1IHNrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:47:20 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:45028 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab1IHNrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:47:19 -0400
X-Greylist: delayed 1079 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Sep 2011 09:47:18 EDT
Date: Thu, 8 Sep 2011 15:27:56 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
Message-ID: <20110908132756.GT31717@ics.muni.cz>
References: <20110720082640.GZ7561@ics.muni.cz>
 <4E280964.6070000@ct.jp.nec.com>
 <20110721132627.GY7561@ics.muni.cz>
 <4E291F28.2040609@ct.jp.nec.com>
 <20110722081903.GB7561@ics.muni.cz>
 <4E2A7806.1060601@ce.jp.nec.com>
 <20110724221619.GM16487@ics.muni.cz>
 <4E367256.8020206@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E367256.8020206@ct.jp.nec.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.17.147
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 08 Sep 2011 15:29:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 06:31:02PM +0900, Kiyoshi Ueda wrote:
> Hi Lukas,
> 
> Lukas Hejtmanek wrote:
> > On Sat, Jul 23, 2011 at 04:28:06PM +0900, Jun'ichi Nomura wrote:
> >> As Kiyoshi suggested, it is important to know whether this
> >> problem occurs with the latest kernel.
> >> So if you could try 3.0, it would be very helpful.
> > 
> > so, do I need to check recent kernel as the patch works for me?
> 
> Yes, please.
> (Unfortunately my storage has been broken today :-<)
> 
> CPU usage seems to be one of the reasons for your case, but I
> still cannot understand why memory pressure is needed.
> I want to know your problem also occurs on 3.0 without the patch.

Well, I tried 3.0.3 kernel. It is not so bad as 2.6.32.36, but it is not as
good as the same kernel with your patch.

CPU load is caused by ksoftirqd (30-40%) and kworker (30%).

Overal speed is about 2.5GB/s. With your patch I can reach 2.8-2.9GB/s.

-- 
Luká¹ Hejtmánek
