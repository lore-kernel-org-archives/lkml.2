Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0LQGul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:50:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LQGuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YkItZVNBDBXKHKFNAMCdoGaPvSvlOkiBmqlEFHVARvxdih+0CvKlDpNO6Ya7PhKcZq
         8QS/mfE/0qiJGMhzDaUL/PqDXlP+BdA6SzCwzU38PBaM4BJ7Bqb6vG4AeQ8yv+iIGdSR
         v5RukkrwA+GkF6hbjxonktLAuyRVOsGM4OUww=
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Junchang Wang <junchangwang@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "Tang, Xinan" <xinan.tang@intel.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=oXCqPHYs9reF9WL46Wxi_b8vL_NMSsAJJ34wD@mail.gmail.com>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	 <46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	 <1292446118.2603.11.camel@edumazet-laptop>
	 <20101216011425.GA17446@linux-os.sc.intel.com>
	 <AANLkTingt6SM+uasicwPSJRE5vYpvJ=GyFf3bbKhO72G@mail.gmail.com>
	 <AANLkTi=oXCqPHYs9reF9WL46Wxi_b8vL_NMSsAJJ34wD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 07:50:34 +0100
Message-ID: <1292568634.2655.31.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 17 décembre 2010 à 14:22 +0800, Junchang Wang a écrit :
> On Thu, Dec 16, 2010 at 9:28 AM, Changli Gao <xiaosuo@gmail.com> wrote:
> > On Thu, Dec 16, 2010 at 9:14 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> >>
> >> SKF_AD_QUEUE doesn't know number of rx queues. Thus user application can't
> >> specify right SKF_AD_QUEUE.
> >
> > It is wrong. AFAIK, you can get the queue number through
> > /sys/class/net/eth*/queues/ or /proc/interrupts
> >
> 
> Valuable comment. Thanks.
> 
> >
> > If you turn to SKF_AD_QUEUE, I think no patch for kernel is needed.
> >
> This patch set is about parallelization of socket interfaces to gain
> performance boost (say, from 1Mpps to around 5Mpps), rather than
> simply bounding socket to cpu/queue. Therefore, it does worth having.
> 

Definitely, but this needs to be designed so that it can be used by even
dumb applications :)



