Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0IYJSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 05:18:33 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49767 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab0IYJSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 05:18:32 -0400
Message-ID: <4C9DBE65.6040606@kernel.dk>
Date: Sat, 25 Sep 2010 11:18:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mark Lord <mlord@pobox.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, hch@lst.de,
        IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] fix blk-exec.c compile error: always define  'sysctl_hung_task_timeout_secs'
 (resend)
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com> <4C9CEFD6.3000106@kernel.dk>  <20100924202106.GC7145@redhat.com> <1285364797.12723.1.camel@corey>
In-Reply-To: <1285364797.12723.1.camel@corey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-24 23:46, Mark Lord wrote:
> Ensure that 'sysctl_hung_task_timeout_secs' is defined
> even when CONFIG_DETECT_HUNG_TASK is not set.
> This way we can safely reference it without need for
> ifdefs in the code elsewhere.  eg. in block/blk-exec.c

Thanks Mark, applied.

-- 
Jens Axboe

