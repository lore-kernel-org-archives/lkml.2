Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0LQGXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:23:03 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:55343 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab0LQGXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fkbpbcXNqqzazl6Bn1OzXACHOT16Jim31gcK/x0L7vE3iEpYcar+HVmoej+/7tI3Oj
         sX1JM6Wf3fOuoxxG6KmwpW0njY+mWIrWtl5a0pd53dW5f4ThVRueyo2Fqi5FN4Da59f4
         vINBfRUJSRvZlEwnK+PKKkPlp2mZ2y3VlpJRg=
MIME-Version: 1.0
In-Reply-To: <AANLkTingt6SM+uasicwPSJRE5vYpvJ=GyFf3bbKhO72G@mail.gmail.com>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	<46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	<1292446118.2603.11.camel@edumazet-laptop>
	<20101216011425.GA17446@linux-os.sc.intel.com>
	<AANLkTingt6SM+uasicwPSJRE5vYpvJ=GyFf3bbKhO72G@mail.gmail.com>
Date: Fri, 17 Dec 2010 14:22:59 +0800
Message-ID: <AANLkTi=oXCqPHYs9reF9WL46Wxi_b8vL_NMSsAJJ34wD@mail.gmail.com>
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Junchang Wang <junchangwang@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "Tang, Xinan" <xinan.tang@intel.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 9:28 AM, Changli Gao <xiaosuo@gmail.com> wrote:
> On Thu, Dec 16, 2010 at 9:14 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
>>
>> SKF_AD_QUEUE doesn't know number of rx queues. Thus user application can't
>> specify right SKF_AD_QUEUE.
>
> It is wrong. AFAIK, you can get the queue number through
> /sys/class/net/eth*/queues/ or /proc/interrupts
>

Valuable comment. Thanks.

>
> If you turn to SKF_AD_QUEUE, I think no patch for kernel is needed.
>
This patch set is about parallelization of socket interfaces to gain
performance boost (say, from 1Mpps to around 5Mpps), rather than
simply bounding socket to cpu/queue. Therefore, it does worth having.


Thanks.
-- 
--Junchang
