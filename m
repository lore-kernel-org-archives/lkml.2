Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab1C3FVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:21:45 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:47288 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750912Ab1C3FVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:21:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BT0R7MVKHgZHzaX9vAPIfqrpo1dz5zWYmWvH20aeETlyC3phdFOeVLxUSK187XKnaWn4fhwTGj3koF4Mp9B1a9+j6NLi1WGndc0cOcXu2vqxQ7BNXICt265O2zUbv73i;
Date: Tue, 29 Mar 2011 22:21:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: jmheo <jongman.heo@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: compile error with 2.6.39-rc1 (in arch/x86/kernel/apb_timer.c)
Message-Id: <20110329222140.5c33df59.rdunlap@xenotime.net>
In-Reply-To: <20110330022138.GG8529@home.goodmis.org>
References: <loom.20110330T040947-18@post.gmane.org>
	<20110330022138.GG8529@home.goodmis.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 22:21:38 -0400 Steven Rostedt wrote:

> On Wed, Mar 30, 2011 at 02:11:57AM +0000, jmheo wrote:
> > 
> > I got following compile error with 2.6.39-rc1.
> > 
> > arch/x86/kernel/apb_timer.c: In function ??apbt_setup_irq??:
> > arch/x86/kernel/apb_timer.c:319:2: error: implicit declaration of function ??
> > __set_irq_handler??
> > make[2]: *** [arch/x86/kernel/apb_timer.o] Error 1
> > make[1]: *** [arch/x86/kernel] Error 2
> > make: *** [arch/x86] Error 2
> > make: *** Waiting for unfinished jobs....
> > 
> > 
> > I have CONFIG_APB_TIMER & CONFIG_SMP in my .config.
> 
> Could you post your full config please.

allmodconfig fails on i386.

Fix is here:
http://www.spinics.net/lists/linux-tip-commits/msg11524.html

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
