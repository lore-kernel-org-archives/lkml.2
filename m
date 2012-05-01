Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab2EABrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:47:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44895 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab2EABrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:47:12 -0400
Date: Mon, 30 Apr 2012 21:46:01 -0400 (EDT)
Message-Id: <20120430.214601.539803492818231876.davem@davemloft.net>
To: sam@ravnborg.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [patch 23/29] sparc: Use generic init_task
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120430211054.GA8986@merkur.ravnborg.org>
References: <alpine.LFD.2.02.1204302239000.6271@ionos>
	<alpine.LFD.2.02.1204302303390.6271@ionos>
	<20120430211054.GA8986@merkur.ravnborg.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 18:46:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 30 Apr 2012 23:10:54 +0200

> On Mon, Apr 30, 2012 at 11:04:39PM +0200, Thomas Gleixner wrote:
>> On Mon, 30 Apr 2012, Thomas Gleixner wrote:
>> > On Mon, 30 Apr 2012, Sam Ravnborg wrote:
>> > > This breaks sparc build as it has the following in arch/sparc/Makefile:
>> > > 
>> > >     head-y                 += arch/sparc/kernel/init_task.o
>> > 
>> > Hrmm, I thought I had catched all of this nonsense.
>> 
>> Updated version below.
>> 
>> Thanks,
>> 
>> 	tglx
>> 
>> -------------------->
>> Subject: sparc: Use generic init_task
>> From: Thomas Gleixner <tglx@linutronix.de>
>> Date: Mon, 30 Apr 2012 16:48:55 +0200
>> 
>> Same code. Use the generic version. The special Makefile treatment is
>> pointless anyway as init_task.o contains only data which is handled by
>> the linker script. So no point on being treated like head text.
>> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: "David S. Miller" <davem@davemloft.net>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: David S. Miller <davem@davemloft.net>
