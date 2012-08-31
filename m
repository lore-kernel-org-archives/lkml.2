Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab2HaDsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 23:48:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2HaDsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 23:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfuBxyQc-XeNHxw0_XDs0JuCrNArNzcgsmrLya4ncDvSojZxQ@mail.gmail.com>
References: <cover.1345978012.git.joe@perches.com> <CAJfuBxyQc-XeNHxw0_XDs0JuCrNArNzcgsmrLya4ncDvSojZxQ@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 30 Aug 2012 21:48:12 -0600
Message-ID: <CAJfuBxyToA9-=c3H88GGba3GFX64kdbP4OCEC0f4trnBnjpU-w@mail.gmail.com>
Subject: Re: [PATCH 0/5] dev_<level> and dynamic_debug cleanups
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Baron <jbaron@redhat.com>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:43 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Sun, Aug 26, 2012 at 5:25 AM, Joe Perches <joe@perches.com> wrote:
>> The recent commit to fix dynamic_debug was a bit unclean.
>> Neaten the style for dynamic_debug.
>> Reduce the stack use of message logging that uses netdev_printk
>> Add utility functions dev_printk_emit and dev_vprintk_emit for /dev/kmsg.
>>
>> Joe Perches (5):
>>   dev_dbg/dynamic_debug: Update to use printk_emit, optimize stack
>>   netdev_printk/dynamic_netdev_dbg: Directly call printk_emit
>>   netdev_printk/netif_printk: Remove a superfluous logging colon
>>   dev: Add dev_vprintk_emit and dev_printk_emit
>>   device and dynamic_debug: Use dev_vprintk_emit and dev_printk_emit
>>
>
> Ive tested this on 2 builds differing only by DYNAMIC_DEBUG
> It works for me on x86-64
>
> However, I just booted a non-dyndbg build on x86-32, and got this.
>

Ok, transient error, went away with a clean build.

tested-by: Jim Cromie <jim.cromie@gmail.com>

thanks
