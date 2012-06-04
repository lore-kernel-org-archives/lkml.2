Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242Ab2FDXvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:51:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51699 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2FDXvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:51:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120604100700.GA4948@sgi.com>
References: <20120601155447.GG3671@sgi.com>
	<CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
	<20120604100700.GA4948@sgi.com>
Date: Mon, 4 Jun 2012 16:51:19 -0700
X-Google-Sender-Auth: -DFRl73XqIpPXq27AGIKLy_IpCM
Message-ID: <CAE9FiQW_yBZZKsVt5Fy7QEqa7hBXhfbka4Ubh=oz4hDOzLQ0mg@mail.gmail.com>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
From: Yinghai Lu <yinghai@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 3:07 AM, Robin Holt <holt@sgi.com> wrote:
> On Sun, Jun 03, 2012 at 12:00:29AM -0700, Yinghai Lu wrote:
>> On Fri, Jun 1, 2012 at 8:54 AM, Robin Holt <holt@sgi.com> wrote:
>> > I just tried to boot an 8TB system.  It fails very early in boot with:
>> >
>> > Kernel panic - not syncing: Cannot find space for the kernel page tables
>> >
>> >
>> > A git bisect lead me to commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.
>> >
>> > A git revert of that commit based on Linus' current as of a few hours ago
>> > (commit fb21aff) does boot past that point on the 8TB configuration.
>>
>> have some local patches. please check if they are helping...
>
> I will not have access to the machine until late tonight/early tomorrow
> (approximately 24 hours from now).  I will try to give the patches a
> run then.  Would you like them tested individually or as a set?

only_need_recalculate_for_low.patch

should be enough.

Thanks

Yinghai
