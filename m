Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0KBUyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:54:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53856
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111Ab0KBUya convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:54:30 -0400
Date: Tue, 02 Nov 2010 13:54:54 -0700 (PDT)
Message-Id: <20101102.135454.104042709.davem@davemloft.net>
To: airlied@gmail.com
Cc: yong.zhang0@gmail.com, peterz@infradead.org, mingo@redhat.com,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: lockdep and oops_in_progress
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTik68yb2JUL14tnzWfyT1J_50LqFmTs8AdDvC+4p@mail.gmail.com>
References: <1280995849.1923.1515.camel@laptop>
	<20100805145940.GA8685@zhy>
	<AANLkTik68yb2JUL14tnzWfyT1J_50LqFmTs8AdDvC+4p@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Date: Wed, 3 Nov 2010 06:51:07 +1000

>> commit e0fdace10e75dac67d906213b780ff1b1a4cc360
>> Author: David Miller <davem@davemloft.net>
>> Date:   Fri Aug 1 01:11:22 2008 -0700
>>
>>    debug_locks: set oops_in_progress if we will log messages.
>>
>>    Otherwise lock debugging messages on runqueue locks can deadlock the
>>    system due to the wakeups performed by printk().
>>
>>    Signed-off-by: David S. Miller <davem@davemloft.net>
>>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>> Seems we can revert that commit now because of 'robustify printk'.

I completely agree, this can definitely be reverted.

Thanks!
