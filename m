Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2CaVgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:36:21 -0400
Received: from seven.medozas.de ([188.40.89.202]:52565 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab2CaVgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:36:18 -0400
Date: Sat, 31 Mar 2012 23:36:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [RFC] [PATCH 1/2] binary stream format for /proc/stat
In-Reply-To: <CABEgKgo7DUZj9NAdHoEiSDv0_kTNFFjD04T6AKc19WavmGiNog@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1203312329500.16267@frira.zrqbmnf.qr>
References: <4F718007.4000401@jp.fujitsu.com> <alpine.LNX.2.01.1203311639530.8967@frira.zrqbmnf.qr> <CABEgKgo7DUZj9NAdHoEiSDv0_kTNFFjD04T6AKc19WavmGiNog@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-03-31 23:23, Hiroyuki Kamezawa wrote:
>>
>> Rather than adding more obscure formats and fields to /proc(/N)/stat, we
>> should pursue descriptive lines like in /proc/N/status.
>> Or, if so desired, sysfs-style splitted attributes where the filename
>> takes on the description.
>
>Yes, I like format like /proc/N/status , /proc/meminfo...which is
>readable to me.
>But when I wrote this patch, I didn't want to break current format.
>
>My concern on sysfs-style one data per a file is that it will add many
>open/close and making top/ps/sar slow.

Or you go netlink. That gives you a binary format.

That said however, binary does not always mean faster. (It's curious
to see that generating and grepping through the text dump of the
Windows registry is faster than letting regedit.exe search through
the binary tree.)
