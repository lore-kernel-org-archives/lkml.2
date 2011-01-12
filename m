Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1ALPD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:03:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab1ALPDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:03:24 -0500
Date: Wed, 12 Jan 2011 16:02:46 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: qemu-kvm defunct due to THP [was: mmotm 2011-01-06-15-41
 uploaded]
Message-ID: <20110112150246.GX9506@random.random>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
 <4D2B19C5.5060709@gmail.com>
 <20110110150128.GC9506@random.random>
 <4D2B73FA.807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B73FA.807@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:02:50PM +0100, Jiri Slaby wrote:
> Yup, this works for me. If you point me to the other 2, I will test them
> too...

Sure, and they're already included in -mm.

http://marc.info/?l=linux-mm&m=129442647907831&q=raw
http://marc.info/?l=linux-mm&m=129442718808733&q=raw
http://marc.info/?l=linux-mm&m=129442733108913&q=raw

I also included in aa.git the other fixes for migrate deadlocks
(anon_vma huge non-huge probably only reproducible with preempt but
theoretically not only preempt issues, lock_page readahead with slub,
and ksm-lru-drain accounting fix for one ltp ksm testcase) if you want
to test that too (they're in -mm as well of course).

Thanks,
Andrea
