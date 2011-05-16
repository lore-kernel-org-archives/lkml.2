Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1EPPKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:10:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1EPPKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:10:45 -0400
Message-ID: <4DD13E49.6070508@redhat.com>
Date: Mon, 16 May 2011 18:10:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net
Subject: Re: [PATCH v2] posix-timers: RCU conversion
References: <4D8773AA.8030408@redhat.com>	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>	 <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com>	 <1300727545.2884.513.camel@edumazet-laptop>	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>	 <1300746429.2837.20.camel@edumazet-laptop>	 <1300777760.2837.38.camel@edumazet-laptop>	 <1301849660.2837.211.camel@edumazet-laptop>	 <1301940501.2319.25.camel@work-vm>  <20110405144836.GA17490@redhat.com> <1302016682.3171.19.camel@edumazet-laptop>
In-Reply-To: <1302016682.3171.19.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 06:18 PM, Eric Dumazet wrote:
> [PATCH v2] posix-timers: RCU conversion
>

<snip>

Andrew, I see this in -mmotm, but I see v1, not v2.

-- 
error compiling committee.c: too many arguments to function

