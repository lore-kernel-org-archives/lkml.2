Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2HVMx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:53:29 -0400
Received: from host86-151-170-244.range86-151.btcentralplus.com ([86.151.170.244]:55117
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab2HVMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:53:24 -0400
Message-ID: <5034D638.3070308@oak.selfip.net>
Date: Wed, 22 Aug 2012 13:53:12 +0100
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120815 Thunderbird/15.0
MIME-Version: 1.0
To: Neal Cardwell <ncardwell@google.com>
CC: Artem Savkov <artem.savkov@gmail.com>, Shaun Ruffell <sruffell@digium.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: BUG: unable to handle kernel paging request at 00010016
References: <502ECC74.9030605@oak.selfip.net> <20120819042543.GA14461@digium.com> <20120819082117.GA4634@thinkpad.lan> <5032D0C0.4080908@oak.selfip.net> <CADVnQykZv-VfScHSDkNXau1Pn765+fhyZOJce_R5uTbvmUCUpA@mail.gmail.com>
In-Reply-To: <CADVnQykZv-VfScHSDkNXau1Pn765+fhyZOJce_R5uTbvmUCUpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/2012 14:46, Neal Cardwell wrote:
> On Mon, Aug 20, 2012 at 8:05 PM, Dave Haywood <tla@oak.selfip.net> wrote:
>> Bisected to:
>>
>> 5d299f3d3c8a2fbc732b1bf03af36333ccec3130 is the first bad commit
>>
>> commit 5d299f3d3c8a2fbc732b1bf03af36333ccec3130
>>
>> Author: Eric Dumazet <edumazet@google.com>
>>
>> Date:   Mon Aug 6 05:09:33 2012 +0000
>>
>>      net: ipv6: fix TCP early demux
> Yes, this is expected. There was a fix checked into the "net" tree yesterday:
>
> http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commitdiff;h=fae6ef87faeb8853896920c68ee703d715799d28
>
> Please let us know if that doesn't fix the crashes for you.

   Yes, this fixes the crash for me.

   Thanks!

Dave.

