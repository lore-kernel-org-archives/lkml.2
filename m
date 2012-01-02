Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2ABNvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:51:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2ABNu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:50:59 -0500
Date: Mon, 2 Jan 2012 14:48:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
Message-ID: <20120102134856.GA32673@elte.hu>
References: <20111221123624.193898256@goodmis.org>
 <20120101180949.GA25066@elte.hu>
 <20120102105856.GA6661@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102105856.GA6661@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Just to give you an impression of how a failure looks like, the 
> serial console just stops printing mid-line:
> 
>  [   53.212942] calling  vt1211_init+0x0/0x9b @ 1                                                   
>  [   53.212971] initcall vt1211_init+0x0/0x9b returned -19 after 23 usecs                           
>  [   53.212975] calling  sm_vt8231_init+0x0/0x1b @ 1                                                
>    Booting 'Fedora'
> 
> and the next message is GRUB's 'Booting ...' line.

here's another one:

[   53.224579] calling  sm_via686a_init+0x0/0x1b @ 1                                               
[   53.224622] bus: 'pci': add driver via686a                                                      
  Booting 'Fedora

This occured after a series of 50 successful bootups ...

Unfortunately this means that the 'baseline' numbers are 
probably not reliable.

Thanks,

	Ingo
