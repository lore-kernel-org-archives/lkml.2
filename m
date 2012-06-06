Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2FFGh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:37:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:57601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2FFGh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:37:28 -0400
Message-ID: <4FCEFA99.2060405@kernel.dk>
Date: Wed, 06 Jun 2012 08:37:13 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Valdis Kletnieks <valdis.kletnieks@vt.edu>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: next-20120604 WARNING: at block/blk-cgroup.c:867
References: <3785.1338953020@turing-police.cc.vt.edu>
In-Reply-To: <3785.1338953020@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 05:23 AM, Valdis Kletnieks wrote:
> Seen in my dmesg at boot:
> 
> [    0.682289] cryptomgr_test (30) used greatest stack depth: 6344 bytes left
> [    0.683288] io scheduler noop registered
> [    0.683292] io scheduler deadline registered
> [    0.683294] ------------[ cut here ]------------
> [    0.683300] WARNING: at block/blk-cgroup.c:867 blkcg_policy_register+0x41/0x10a()

This is fixed in my for-linus branch, it'll go out shortly.

-- 
Jens Axboe

