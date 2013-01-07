Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3AGRqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:46:09 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53780 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3AGRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:46:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130107173906.GL2525@linux.vnet.ibm.com>
References: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
	<1354179992.2499.35.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hysBreTXE-rXVQ5no+3B8hZ-3XMgap20PAP9u76-j-Tgg@mail.gmail.com>
	<20121129113627.GS2474@linux.vnet.ibm.com>
	<1354256362.2552.6.camel@ThinkPad-T5421.cn.ibm.com>
	<20130107173906.GL2525@linux.vnet.ibm.com>
Date: Mon, 7 Jan 2013 18:46:07 +0100
Message-ID: <CAFTL4hx7Z6WPWnhQVY=ea31kfi1yp8b_Jm-L-kNLUDani7fCbA@mail.gmail.com>
Subject: Re: [PATCH rcu] Remove unused code originally used for context tracking
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad.Ben-Yossef.gilad@benyossef.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/7 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Fri, Nov 30, 2012 at 02:19:22PM +0800, Li Zhong wrote:
>> As new context tracking subsystem added, it seems ignore_user_qs and
>> in_user defined in struct rcu_dynticks are no longer needed, so remove
>> them.
>>
>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
>
> Hearing no objections from  Frederic, I have queued this patch for 3.9

Thanks Paul!

And feel free to add my ack.
