Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1EDOi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:38:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1EDOiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:38:46 -0400
Date: Wed, 4 May 2011 16:38:42 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
Message-ID: <20110504143842.GK7838@random.random>
References: <4DAF6C0B.3070009@gmx.de>
 <20110427134613.GI32590@random.random>
 <4DC14474.9040001@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC14474.9040001@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Wed, May 04, 2011 at 02:20:04PM +0200, Thomas Sattler wrote:
> Different machine (kernel 2.6.38.2) 4x SYSRQ+l
> 
>    http://pastebin.com/raw.php?i=B2XeVyz6
>     (URL should be valid for one month)
> 
> Since this is a DualCore machine, it is still
> quite usable. I'll try to keep it running, in
> case you need more details.
> 
> BTW: I haven't seen the problem with 2.6.38.4
> so far. May have been fixed in the meantime?

There's no sign of khugepaged in the traces :( and one of the two cpu
is always idle (the other is often idle too). Maybe khugepaged was
stuck in D state and that is shown as 100% load for iotop? Please next
time can you run SYSRQ+t too in addition of SYSRQ+l? (I should have
suggested it right away but I thought khugepaged was running at 100%
cpu load and sysrq+t wouldn't have been as interesting in that
case). You can run also a "ps xal" to see the actual scheduler task
state. I suggest to stay at .2 if it reproduces it more easily.

If we understand what it is, it'll be easy to tell if it was already
fixed in 2.6.38.4 but I doubt unless it's not related to MM.

Thanks a lot for the help,
Andrea
