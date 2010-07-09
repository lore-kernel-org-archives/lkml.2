Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0GIPvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:51:49 -0400
Received: from postin.uv.es ([147.156.1.90]:39740 "EHLO postin.uv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab0GIPvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:51:47 -0400
Message-ID: <4C37431C.2030107@postal.uv.es>
Date: Fri, 09 Jul 2010 17:41:16 +0200
From: Enrico Bandiello <enban@postal.uv.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>	<AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com> <20100709081239.4eb8fddd@virtuousgeek.org>
In-Reply-To: <20100709081239.4eb8fddd@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Userflux: User e-mail Flow checked by Userflux
X-RelayDelay-Mem: Whitelisted relay grajo.ci.uv.es [147.156.0.253]. Not delayed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 05:12 PM, Jesse Barnes wrote:
> On Thu, 8 Jul 2010 18:34:25 -0700
> Linus Torvalds<torvalds@linux-foundation.org>  wrote:
>
>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16307
>>> Subject         : i915 in kernel 2.6.35-rc3, high number of wakeups
>>> Submitter       : Enrico Bandiello<enban@postal.uv.es>
>>> Date            : 2010-06-26 16:57 (13 days old)
>>> Message-ID      :<4C26317A.5070309@postal.uv.es>
>>> References      : http://marc.info/?l=linux-kernel&m=127757403404259&w=2
>>
>> I don't think anybody noticed this one. Jesse?
>
> Oh I hadn't seen that...  Enrico, can you bisect this issue?  It could
> be some spurious hotplug events or possibly a stuck vblank interrupt...


Well... Let me try; being the firts time I send a bug report I've just 
to learn how to do this kind of stuff. In this moment I'm compiling -rc4 
to see if the "problem" persists. After, I'll try to go on with bisecting.
