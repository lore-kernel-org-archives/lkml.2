Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1C3CVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:21:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab1C3CVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:21:40 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=6e3NE4ipf18A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=x_8WmpnFefx8bMLz5_MA:9 a=YTPq3KvsRY_4v1hzDRrGtJa8qe4A:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 29 Mar 2011 22:21:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: jmheo <jongman.heo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: compile error with 2.6.39-rc1 (in arch/x86/kernel/apb_timer.c)
Message-ID: <20110330022138.GG8529@home.goodmis.org>
References: <loom.20110330T040947-18@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20110330T040947-18@post.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 02:11:57AM +0000, jmheo wrote:
> 
> I got following compile error with 2.6.39-rc1.
> 
> arch/x86/kernel/apb_timer.c: In function ??apbt_setup_irq??:
> arch/x86/kernel/apb_timer.c:319:2: error: implicit declaration of function ??
> __set_irq_handler??
> make[2]: *** [arch/x86/kernel/apb_timer.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
> 
> 
> I have CONFIG_APB_TIMER & CONFIG_SMP in my .config.

Could you post your full config please.

Thanks,

-- Steve
