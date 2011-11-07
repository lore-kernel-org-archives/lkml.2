Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1KGMpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:45:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39584 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755497Ab1KGMpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:45:15 -0500
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX19GMvBRAVRGQoyCWe96w/zAK+HsOHq2DNk1BzNou6
	04SBR59bI+0azq
Message-ID: <4EB7D2D8.2060505@gmx.net>
Date: Mon, 07 Nov 2011 13:45:12 +0100
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
In-Reply-To: <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On 07.11.2011 13:42, Andrea Gelmini wrote:
> 2011/11/7 Arne Jansen <sensille@gmx.net>:
>> On what platform are you running this? Can you please try this after
>> a fresh boot? Maybe there's an allocation that can't be served with
>> a badly fragmented memory.
> 
> Hi Arne,
>    and thanks a lot for your reply.
>    So:
>    a) it's a fresh Ubuntu 11.04, with latest Linus git tree
> (31555213f03bca37d2c02e10946296052f4ecfcd), and latest btrfs progs
> (13eced9a0c2b6bd6bc38e6f0f46a1977b1167e67), plus Chris btrfs branch
> for-linus;
>    b) same problem after a fresh boot.

is it 32 or 64 bit?

Thanks,
Arne

> 
> Thanks,
> Andrea

