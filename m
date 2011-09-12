Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1ILIjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 04:39:17 -0400
Received: from lucidpixels.com ([72.73.18.11]:55327 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1ILIjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:39:16 -0400
Date: Mon, 12 Sep 2011 04:39:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues? [again w/DEBUG_VM
 & SLAB_DEBUG enabled]
In-Reply-To: <CAF1ivSa8fFq6hemzJr6A_kgfNN4tOeEfD8kGfx==7JKV6M2hDg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1109120438340.16088@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan> <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan> <alpine.DEB.2.02.1109120351470.16088@p34.internal.lan> <CAF1ivSa8fFq6hemzJr6A_kgfNN4tOeEfD8kGfx==7JKV6M2hDg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1469147682-1315816756=:16088"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1469147682-1315816756=:16088
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 12 Sep 2011, Lin Ming wrote:

>> [27336.007233] =A0[<ffffffff81089fc3>] kswapd+0xb3/0x250
>> [27336.007237] =A0[<ffffffff8104fea0>] ? abort_exclusive_wait+0xb0/0xb0
>> [27336.007241] =A0[<ffffffff81089f10>] ? balance_pgdat+0x6a0/0x6a0
>> [27336.007244] =A0[<ffffffff8104f457>] kthread+0x87/0x90
>> [27336.007248] =A0[<ffffffff81648814>] kernel_thread_helper+0x4/0x10
>> [27336.007252] =A0[<ffffffff8104f3d0>] ? kthread_flush_work_fn+0x10/0x10
>> [27336.007256] =A0[<ffffffff81648810>] ? gs_change+0xb/0xb
>
> No more info got.
>
> Could you try to make a test case which can trigger this bug reliably?
> You may also try some benchmarks, for example, fio, ffsb, etc.
>
> Lin Ming

Hi,

I do not unfortunately, it seems to occur at random times during heavy I/O+
mem and processing time, are there any other debug options that would help =
us
here?

Justin.

--655872-1469147682-1315816756=:16088--
