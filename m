Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1GYB5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:57:33 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51120 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab1GYB5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1107241204300.2702@ionos>
References: <alpine.LFD.2.02.1107231706380.2702@ionos>
	<20110724010932.GA2133@zhy>
	<alpine.LFD.2.02.1107241204300.2702@ionos>
Date: Mon, 25 Jul 2011 09:57:29 +0800
Message-ID: <CAM2zO=BChj0-zKgQTC7wia8Ou8wCVYR9U+yuF3DC4SvvQJtqkQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt2
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 6:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 24 Jul 2011, Yong Zhang wrote:
>> [ 1244.912621]  [<c15d151c>] rt_spin_lock+0x1c/0x40
>> [ 1244.912626]  [<c111f763>] mem_cgroup_split_huge_fixup+0x43/0xd0
>
> Can you please disable CONFIG_TRANSPARENT_HUGEPAGE for now? That's not
> easy to fix, but I put it on the todo list.

That's ok.
Will try 3.0-rt3 :)

Thanks,
Yong



-- 
Only stand for myself
