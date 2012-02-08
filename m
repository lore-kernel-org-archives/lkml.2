Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2BHPVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:21:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab2BHPVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:21:45 -0500
Date: Wed, 8 Feb 2012 16:15:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: WANG Cong <xiyou.wangcong@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + proc-clean-up-proc-pid-environ-handling.patch added to -mm
	tree
Message-ID: <20120208151516.GA15570@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cong Wang <xiyou.wangcong@gmail.com>
> Subject: proc: clean up /proc/<pid>/environ handling
>
> Similar to e268337dfe2 ("proc: clean up and fix /proc/<pid>/mem
> handling"),

and has the same problem,

> move the check of permission to open(), this will simplify
> read() code.

but allows to kill the system trivially.

Please look at 6d08f2c7139790c268820a2e590795cb8333181a
"proc: make sure mem_open() doesn't pin the target's memory"

Oleg.

