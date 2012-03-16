Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965488Ab2CPLQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:16:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61897 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761366Ab2CPLQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120314110844.d1654724.kamezawa.hiroyu@jp.fujitsu.com>
References: <CACVxJT_UWzpVo1Jfbf5Z2A-s16QjEv05MiNSY_EGihKTPuMyxg@mail.gmail.com>
	<20120314093156.2bc3d3c5.kamezawa.hiroyu@jp.fujitsu.com>
	<20120314110844.d1654724.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 16 Mar 2012 13:16:17 +0200
Message-ID: <CACVxJT9mkX+7+hFrbt2rNCjUH9Y=t2AtGaXqcGfMh6x5WwMjmw@mail.gmail.com>
Subject: Re: seq_put_decimal_ull() et al
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 5:08 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 14 Mar 2012 09:31:56 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Tue, 13 Mar 2012 15:35:54 +0200
>> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>
>> > > Subject:    + procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch added to -mm tree
>> >
>> > I think the fix is to create proper binary interface for exporting
>> > interrupt counts.
>> > Programs can parse raw data equally well if programming language is
>> > even minimally reasonable
>> > (POSIX shell may not qualify, though).
>>
>> Ok, please try with all tool-chain updates.
>> procps, top, sar, and more ?
>>

Well, why not?
We can tune print code or we can create maximally fast interface and forget.

> One concern is maintainance of 2 files of the same data.

The other is all those multiplying print functions.
