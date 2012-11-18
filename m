Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2KRJa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 04:30:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43734 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2KRJay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 04:30:54 -0500
MIME-Version: 1.0
In-Reply-To: <50A07768.5010704@redhat.com>
References: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
	<50A07768.5010704@redhat.com>
Date: Sun, 18 Nov 2012 17:30:52 +0800
Message-ID: <CAJRGBZymTYDi+hfDUcA2jLGb7iXeueEza5S=pMf2Qsxi81o84Q@mail.gmail.com>
Subject: Re: [PATCH update 0/3] HW-latency: hardware latency test 0.10
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, Jon Masters <jcm@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 12:13 PM, Jon Masters <jcm@redhat.com> wrote:
> On 11/10/2012 09:48 PM, Luming Yu wrote:
>
>> Update the previous patch series to ACK all comments I've recevied so far
>> for the tool: e.g. 1.Acked Jon Masters in source code as many code are from
>> jcm, thanks very much Jon. 2. squashed all changes against new file I added into
>> one. 3. Make it useful on non-x86.
>
> Thanks for taking this and doing the heavy lifting to get it upstream! I
> wrote the original SMI detector really for RT debug purposes as we had
> OEM systems that would generate large latencies and it was easier to
> prove the point with nice graphs showing where the BIOS was injecting
> unwanted SMIs. Glad to see the work being done to make it more generic
> in nature. Maybe I'll come back with some ARM patches ;)
>
> Actually this exercise was very informative because it has helped shape
> my input on ARMv8 designs. I'm very keen to get away from a world in
> which world+dog feature is implemented inside an SMI-like context. It
> should be done via a dedicated management processor (on-chip) instead.
>
> Jon.
>

thanks Jon,

ping Arnd,  would you take this into your tree?

The value is when the feature finally done, we can finally have a
reliable tool  to count on for automatically sorting out hardware
problems and differences that really matter to designing your software
stack on bare metal, which means a lot to many of us dedicated to
hardware development/enabling as a software engineer, especially when
you have two similar platforms and need to rule out hardware latency
that could be the root cause.. in many case, people would have to dig
into various specs and lost...

I'd be glad to do anything to push this tool into upstream.  Please
let me know your thoughts. Thanks !!!! /l
