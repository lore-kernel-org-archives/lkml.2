Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0ICQzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:55:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54502
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab0ICQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:55:23 -0400
Date: Fri, 03 Sep 2010 09:55:39 -0700 (PDT)
Message-Id: <20100903.095539.220051635.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: herbert@gondor.hengli.com.au, davej@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, menage@google.com
Subject: Re: [PATCH v2] cls_cgroup: Fix rcu lockdep warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C805293.1020305@cn.fujitsu.com>
References: <4C805293.1020305@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Fri, 03 Sep 2010 09:42:43 +0800

> Dave reported an rcu lockdep warning on 2.6.35.4 kernel
> 
> task->cgroups and task->cgroups->subsys[i] are protected by RCU.
> So we avoid accessing invalid pointers here. This might happen,
> for example, when you are deref-ing those pointers while someone
> move @task from one cgroup to another.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Applied, thanks.
