Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab1JDWcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:32:19 -0400
Received: from home.kolivas.org ([59.167.196.135]:40981 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933180Ab1JDWcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:32:18 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
Date: Wed, 5 Oct 2011 09:32:10 +1100
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-ck1; KDE/4.6.2; x86_64; ; )
Cc: Christoph Lameter <cl@gentwo.org>, Joe Perches <joe@perches.com>,
        starlight@binnacle.cx, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx> <alpine.DEB.2.00.1110041501130.16 <87zkhg1ppl.fsf@depni.sinp.msu.ru>
In-Reply-To: <87zkhg1ppl.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110050932.10374.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011 07:12:06 Serge Belyshev wrote:
> BFS FAQ writes:
> > NUMA aware?
> > 
> > It is NOT NUMA aware in the sense that it does any fancy shit on NUMA,
> > but it will work on NUMA hardware just fine. Only the really big NUMA
> > hardware is likely to suffer in performance, and this is theoretically
> > only, since no one has that sort of hardware to prove it to me, but it
> > seems almost certain.
> 
> This part of FAQ entry was written before 0.300, (i.e. more than 2 years
> ago)
> 
> > v0.300 onwards have NUMA enhancements.
> 
> And this was added after. =)
> 
> As of now, BFS scheduling is NUMA-aware. (see resched_best_mask())

Admittedly the wording of this got confused as BFS developed. It originally 
had no NUMA enhancements, but now it does. The code to benefit NUMA is quite 
simple though, but then, so is everything in BFS.

Regards,
Con
-- 
-ck
