Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1AUHbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:31:07 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43691 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1AUHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:31:05 -0500
Message-ID: <4D393636.4040607@cs.helsinki.fi>
Date: Fri, 21 Jan 2011 09:31:02 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for this_cpu_cmpxchg_double
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org>
In-Reply-To: <20110108172453.GF13269@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/11 7:24 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Jan 07, 2011 at 12:41:58PM -0600, Christoph Lameter wrote:
>> On Fri, 7 Jan 2011, Mathieu Desnoyers wrote:
>>
>>> I have to admit that I also hate the current interface for two reasons:
>
> Call me weird but I like this one than others.  It sure is ugly but
> the operation itself isn't a particularly pretty so it kinda matches.
> Also, this one is the least error prone and more consistent with other
> cpu ops.

So what are we going to do about this patch? I'd love to merge 
Christoph's SLUB patches for linux-next now that .38-rc1 is out.

			Pekka
