Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab2DAKa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 06:30:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33478 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2DAKaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 06:30:22 -0400
Date: Sun, 1 Apr 2012 13:30:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [RFC] [PATCH 1/2] binary stream format for /proc/stat
Message-ID: <20120401103015.GA3231@p183.telecom.by>
References: <4F718007.4000401@jp.fujitsu.com>
 <alpine.LNX.2.01.1203311639530.8967@frira.zrqbmnf.qr>
 <CABEgKgo7DUZj9NAdHoEiSDv0_kTNFFjD04T6AKc19WavmGiNog@mail.gmail.com>
 <alpine.LNX.2.01.1203312329500.16267@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1203312329500.16267@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 11:36:15PM +0200, Jan Engelhardt wrote:
> 
> On Saturday 2012-03-31 23:23, Hiroyuki Kamezawa wrote:
> >>
> >> Rather than adding more obscure formats and fields to /proc(/N)/stat, we
> >> should pursue descriptive lines like in /proc/N/status.
> >> Or, if so desired, sysfs-style splitted attributes where the filename
> >> takes on the description.
> >
> >Yes, I like format like /proc/N/status , /proc/meminfo...which is
> >readable to me.
> >But when I wrote this patch, I didn't want to break current format.
> >
> >My concern on sysfs-style one data per a file is that it will add many
> >open/close and making top/ps/sar slow.
> 
> Or you go netlink. That gives you a binary format.

And one more system call to acquire necessary data.
