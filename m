Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0G1Oml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:42:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34437 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab0G1Omg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:42:36 -0400
Date: Wed, 28 Jul 2010 20:12:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/7][memcg] towards I/O aware memory cgroup
Message-ID: <20100728144229.GD14369@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-07-27 16:51:55]:

> 
> From a view of patch management, this set is a mixture of a few features for
> memcg, and I should divide them to some groups. But, at first, I'd like to
> show the total view. This set is consists from 5 sets. Main purpose is
> create a room in page_cgroup for I/O tracking and add light-weight access method
> for file-cache related accounting. 
> 
> 1.   An virtual-indexed array.
> 2,3. Use virtual-indexed array for id-to-memory_cgroup detection.
> 4.   modify page_cgroup to use ID instead of pointer, this gives us enough
>      spaces for further memory tracking.

Yes, this is good, I've been meaning to merge the flags and the
pointer. Thanks for looking into this.

> 5,6   Use light-weight locking mechanism for file related accounting.
> 7.   use spin_lock instead of bit_spinlock.
> 
> 
> As a function,  patch 5,6 can be an independent patch and I'll accept
> reordering series of patch if someone requests.
> But we'll need all, I think.
> (irq_save for patch 7 will be required later.)
> 

-- 
	Three Cheers,
	Balbir
