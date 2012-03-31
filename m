Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2CaVXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:23:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42000 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2CaVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.1203311639530.8967@frira.zrqbmnf.qr>
References: <4F718007.4000401@jp.fujitsu.com>
	<alpine.LNX.2.01.1203311639530.8967@frira.zrqbmnf.qr>
Date: Sun, 1 Apr 2012 06:23:31 +0900
Message-ID: <CABEgKgo7DUZj9NAdHoEiSDv0_kTNFFjD04T6AKc19WavmGiNog@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/2] binary stream format for /proc/stat
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年3月31日23:42 Jan Engelhardt <jengelh@medozas.de>:
> On Tuesday 2012-03-27 10:53, KAMEZAWA Hiroyuki wrote:
>
>>Provides another format of /proc/stat for showing data in binary and
>>compress sequence of Zeros to some extent.
>>
>>Any other idea of formats ?
>
> Rather than adding more obscure formats and fields to /proc(/N)/stat, we
> should pursue descriptive lines like in /proc/N/status.
> Or, if so desired, sysfs-style splitted attributes where the filename
> takes on the description.

Yes, I like format like /proc/N/status , /proc/meminfo...which is
readable to me.
But when I wrote this patch, I didn't want to break current format.

My concern on sysfs-style one data per a file is that it will add many
open/close and making top/ps/sar slow.

Thanks,
-Kame
