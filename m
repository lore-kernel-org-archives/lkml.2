Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0DTIhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:37:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0DTIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:36:58 -0400
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BCD646B.1080206@cn.fujitsu.com>
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
	 <20100311032843.GE6767@linux.vnet.ibm.com>
	 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
	 <1271098032.4807.137.camel@twins> <1271242058.32749.19.camel@laptop>
	 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
	 <20100419230136.GA16856@linux.vnet.ibm.com>
	 <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
	 <20100420030452.GB2905@linux.vnet.ibm.com>
	 <4BCD646B.1080206@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 10:36:55 +0200
Message-ID: <1271752615.1676.393.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 16:23 +0800, Lai Jiangshan wrote:
> 
> One variable per usage, so, Now, we can get multiple complaint
> when we detect multiple different suspicious rcu_dereference_check()
> usage.
> 

Ah indeed, very nice.

