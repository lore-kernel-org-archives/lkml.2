Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab2ENVEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:04:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59328 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab2ENVEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:04:40 -0400
Date: Mon, 14 May 2012 16:57:56 -0400 (EDT)
Message-Id: <20120514.165756.1176186192047419316.davem@davemloft.net>
To: tj@kernel.org
Cc: hpa@zytor.com, alex.shi@intel.com, tglx@linutronix.de, mingo@redhat.com,
        cl@linux-foundation.org, tony.luck@intel.com, bp@amd64.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, sfr@canb.auug.org.au,
        luto@mit.edu, glommer@parallels.com, fernando@oss.ntt.co.jp,
        vapier@gentoo.org, eric.dumazet@gmail.com, dzickus@redhat.com,
        dhowells@redhat.com, cbouatmailru@gmail.com, fenghua.yu@intel.com,
        jkosina@suse.cz, ext-phil.2.carmody@nokia.com,
        dan.carpenter@oracle.com, len.brown@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, anton@samba.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] replace percpu_ops function with this_cpu_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120514180128.GC2366@google.com>
References: <20120514173421.GB2366@google.com>
	<4FB142D1.7080403@zytor.com>
	<20120514180128.GC2366@google.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 May 2012 13:58:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Mon, 14 May 2012 11:01:28 -0700

> On Mon, May 14, 2012 at 10:37:21AM -0700, H. Peter Anvin wrote:
>> I would be happier if we kept the patchset together.
>> 
>> So I would greatly prefer if you'd take the whole patchset with my:
>> 
>> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> Yeap, that works too.  David, can I route the network part too with
> your ack?

Sure:

Acked-by: David S. Miller <davem@davemloft.net>
