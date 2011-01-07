Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1AGBbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:31:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26527 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab1AGBbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:31:01 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37: Bug on btrfs while umount
In-reply-to: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com>
References: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com>
Date: Thu, 06 Jan 2011 20:29:12 -0500
Message-Id: <1294363682-sup-7971@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Drunkard Zhang's message of 2011-01-06 20:25:37 -0500:
> Remote terminal hung while umount, here's dmesg:
> 
> [50010.838804] ------------[ cut here ]------------
> [50010.838931] kernel BUG at fs/btrfs/inode.c:1616!
> [50010.839053] invalid opcode: 0000 [#1] PREEMPT SMP
> [50010.839185] last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
> [50010.839307] CPU 0
> [50010.839313] Modules linked in: ipt_addrtype btrfs k10temp
> [50010.839541]
> [50010.839653] Pid: 1681, comm: btrfs-endio-wri Not tainted 2.6.37 #1

Could you please pull from the master branch of the btrfs unstable tree.
We had a late fix that is related to this.

-chris
