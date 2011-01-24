Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1AXGCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 01:02:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50880 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab1AXGCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 01:02:18 -0500
Message-ID: <4D3D15AF.30508@zytor.com>
Date: Sun, 23 Jan 2011 22:01:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for this_cpu_cmpxchg_double
References: <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com> <20110121171914.GJ2832@htj.dyndns.org>
In-Reply-To: <20110121171914.GJ2832@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 09:19 AM, Tejun Heo wrote:
> On Fri, Jan 21, 2011 at 09:13:41AM -0800, H. Peter Anvin wrote:
>> We could do cmpxchg with a structure... the problem with a lon int
>> type is that Cristoph ran into bugs with __int128 on 64 bits.
>
> But, IIRC, the problem with int128 was with passing it as parameter
> and return value.  We don't have to do that.  We'll be just using it
> as a data storage / container type.  Or even that is broken?

Well, part of the point was to pass in registers.

No idea on the data storage type.

	-hpa
