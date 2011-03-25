Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1CYOsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:48:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1CYOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:48:23 -0400
Subject: Re: deadlock caused by printk
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: torvalds@osdl.org, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimw1+6DrYxxzkw7yh-t4W8rM55qcVd1nsQrAYT-@mail.gmail.com>
References: <AANLkTinCk35LSMLyO0nD+Z1ZmZskaCCN5c8kyxLcmXYx@mail.gmail.com>
	 <1301055698.2250.198.camel@laptop> <1301055960.2250.202.camel@laptop>
	 <AANLkTimw1+6DrYxxzkw7yh-t4W8rM55qcVd1nsQrAYT-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 15:50:27 +0100
Message-ID: <1301064627.2250.215.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 22:30 +0800, Ming Lei wrote:
> 
> But seems ftrace can't dump out the messages if system hangs,

True.

>  so could
> we introduce a smart and simple "printk" which can be used in any
> contexts? 

I think you could use early_printk() for that, it doesn't bother with
all the syslog muck.

