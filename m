Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2IOHzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 03:55:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32868 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2IOHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 03:55:38 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120914183410.GH17747@google.com>
References: <20120914131700.dd3d01a7d17b78082a9bcd55@canb.auug.org.au>
	<5052D51D.3060106@bmw-carit.de>
	<20120914170019.GA17747@google.com>
	<CA+icZUWrK10WmS1252kCPMKxfjihz3z5xqvXPGB1Oi13MuOJfw@mail.gmail.com>
	<20120914183410.GH17747@google.com>
Date: Sat, 15 Sep 2012 09:55:36 +0200
Message-ID: <CA+icZUWs5efbRzPKE0HU4+boRkAgXnpsd_PDB=k-Q4aOZ1jWLA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cgroup tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 8:34 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Sep 14, 2012 at 08:32:28PM +0200, Sedat Dilek wrote:
>> Did you pushed this to [1] already?
>
> Was still building.  Pushed out now.
>

Pulled and works fine here!
Thanks to you.

- Sedat -

P.S.: dmesg checks

$ dmesg | egrep 'cgroup|systemd'
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc5-next20120914-3-iniza-generic
root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
init=/lib/systemd/systemd
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc5-next20120914-3-iniza-generic
root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
init=/lib/systemd/systemd
[    0.002082] Initializing cgroup subsys cpuacct
[    0.002087] Initializing cgroup subsys devices
[    0.002089] Initializing cgroup subsys freezer
[    0.002092] Initializing cgroup subsys blkio
[    0.002095] Initializing cgroup subsys perf_event

> Thanks.
>
> --
> tejun
