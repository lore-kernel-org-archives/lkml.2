Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab0EYXKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:10:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41984
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758832Ab0EYXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:10:30 -0400
Date: Tue, 25 May 2010 16:10:40 -0700 (PDT)
Message-Id: <20100525.161040.71125311.davem@davemloft.net>
To: amwang@redhat.com
Cc: hooanon05@yahoo.co.jp, opurdila@ixiacom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc_dointvec, write a single value
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BFBC153.9040704@redhat.com>
References: <4BFB6197.5030206@redhat.com>
	<1274770184-12611-1-git-send-email-hooanon05@yahoo.co.jp>
	<4BFBC153.9040704@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Tue, 25 May 2010 20:23:47 +0800

> On 05/25/10 14:49, J. R. Okajima wrote:
>> The commit 00b7c3395aec3df43de5bd02a3c5a099ca51169f
>> "sysctl: refactor integer handling proc code"
>> modified the behaviour of writing to /proc.
>> Before the commit, write("1\n") to /proc/sys/kernel/printk
>> succeeded. But
>> now it returns EINVAL.
>>
>> This commit supports writing a single value to a multi-valued entry.
>>
>> Signed-off-by: J. R. Okajima<hooanon05@yahoo.co.jp>
> 
> Reviewed-and-tested-by: WANG Cong <amwang@redhat.com>

Since the regression causing change came in via the net tree
I'll integrate this fix too, applied, thanks!
