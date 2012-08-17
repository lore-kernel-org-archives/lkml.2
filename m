Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2HQW5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:57:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58757 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2HQW5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:57:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAEhu1-4gv=uAu7K=O6DqeXr05frD4_Yp+0VnRuF_n8mnbaqF6w@mail.gmail.com>
References: <CAEhu1-4gv=uAu7K=O6DqeXr05frD4_Yp+0VnRuF_n8mnbaqF6w@mail.gmail.com>
Date: Fri, 17 Aug 2012 18:57:44 -0400
Message-ID: <CAEhu1-4A4z570g6+KdiRH4No-q=7hkDymQ+gnwnKwS0E83jUsg@mail.gmail.com>
Subject: Re: mdraid6 problem post 3.5.0
From: John Drescher <drescherjm@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 6:30 PM, John Drescher <drescherjm@gmail.com> wrote:
> For the last few weeks I have been doing some reliability testing on a
>  mdraid6 array. One of my test was to physically hot remove a raid
> member disk. This worked flawlessly with gentoo-sources-3.5.0 for the
> 5 or so times I tried it with my 12 disk + 1 spare mdraid6 array.
> After pulling a disk a few seconds later the array automatically
> rebuilds with a spare and after finishing all data checks out via
> btrfs a scrub. However trying this with gentoo-sources-3.5.2 or the
> latest kernel.org git sources the machine does not start the rebuild
> and any access to /proc/mdstat or and disk access that is not in cache
> for that array just leads to an a long (possibly infinite) wait
> eventually forcing me to have to use the reset button when the sysrq
> key combinations fail to shut down the machine. I do see some kernel
> debug message in the console alt-ctrl-f12 but I was unable to save
> that to copy.
>
> Is this a known problem? If not it may be possible that I could bisect
> this next week to the patch that causes this behavior.
>

The same problem appears on gentoo-sources-3.5.1 so it appears this
problem was introduced between kernels 3.5.0 and 3.5.1. I will have to
debug this next week..

John
