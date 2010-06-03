Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab0FCIlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:41:19 -0400
Received: from troy.hostgo.com ([64.62.143.130]:58626 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab0FCIlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:41:15 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: failed command FLUSH CACHE EXT
Date: Thu, 3 Jun 2010 02:41:10 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.dmz.6-liquorix-amd64; KDE/4.4.3; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <201005292046.06344.tfjellstrom@strangesoft.net> <201006021742.32232.tfjellstrom@strangesoft.net> <4C07666A.7000705@gmail.com>
In-Reply-To: <4C07666A.7000705@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006030241.11102.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On June 3, 2010, Tejun Heo wrote:
> Hello,
> 
> On 06/03/2010 01:42 AM, Thomas Fjellstrom wrote:
> > I seem to have rather bad luck with hard drives. Every time I buy more
> > than two, I tend to get one or two failures out of the batch. 25-50%
> > failure rate almost. Horrible. I at least average 1 dead hard drive a
> > year since I got my first computer.
> 
> Hmmm... that sounds really high.  Out of how many?  Hard drives do
> fail sometimes but not that easily even if you put it under relatively
> heavy use 24/7.  Maybe there is a common cause - say, instable power,
> vibration, impact or whatever?  Or maybe the universe just doesn't
> like you?  :-)
> 
> Thanks.

I think its a combination of factors. But mainly, early on I was cheap. UBER 
cheap, nor did I know that a power supply is probably the /most/ important 
component in a machine. If it helps I've also had many motherboards, tons of 
ram, and some misc other parts fail over the years as well, but I've 
probably gone through more hard drives than anything else.

Let me see if I can count all of them... 

1x6G   - failed
1x40G  - failed
4x80G  - 2 failed (PSU kill)
2x160G - 1 failed (used drives anyhow, don't really count)
4x320G - 2 failed (DOA, well after a week each)
4x640G - 1-2 failed (can't really remember the circumstances with these...)
6x1T   - 1 failed (DOA)
4x2T   - 2 failed (1 DOA, 1 after a year)

So about half.

I mostly blame my cheapness when I was younger. Bad PSU's can cause a lot of 
problems. I've since stopped buying and using cheap power supplies. And it 
has so far made a difference in death count. If I skip the DOA drives, only 
one 1TB, 1 2TB and 1 640 failed. Thats far better than a 50% mortality rate.

That list may not be entirely accurate, it spans over 10 years of hd use. I 
can barely remember what I did the day before, let alone the details of 
things that happened 10 years ago.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
