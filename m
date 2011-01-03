Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980Ab1ACXrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 18:47:16 -0500
Received: from mx5.orcon.net.nz ([219.88.242.55]:41029 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab1ACXrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 18:47:15 -0500
X-Greylist: delayed 4007 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jan 2011 18:47:15 EST
Message-ID: <60180.121.72.232.114.1294094426.squirrel@mail.orcon.net.nz>
In-Reply-To: <20110103205705.GA24522@gherkin.frus.com>
References: <20110103205705.GA24522@gherkin.frus.com>
Date: Tue, 4 Jan 2011 11:40:26 +1300 (NZDT)
Subject: Re: [BUG] 2.6.37-rc8 build failure on Alpha
From: "Michael Cree" <mcree@orcon.net.nz>
To: "Bob Tracy" <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-DSPAM-Check: by mx5.orcon.net.nz on Tue, 04 Jan 2011 11:40:26 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Jan  4 11:40:26 2011
X-DSPAM-Confidence: 0.5707
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, January 4, 2011 9:57 am, Bob Tracy wrote:
> This probably happened before -rc8, but was not an issue for 2.6.36.
>
> The 2.6.37-rc8 kernel build on alpha fails as follows:
>
> (...)
>   LD      usr/built-in.o
>   AS      arch/alpha/kernel/entry.o
>   CC      arch/alpha/kernel/traps.o
> cc1: warnings being treated as errors
> In file included from
> /usr/src/linux-2.6/arch/alpha/include/asm/mmu_context.h:22,
>                  from arch/alpha/kernel/traps.c:26:
> /usr/src/linux-2.6/arch/alpha/include/asm/io.h: In function '__set_hae':
> /usr/src/linux-2.6/arch/alpha/include/asm/io.h:41: error:
> 'arch_local_irq_save' is static but used in inline function '__set_hae'
> which is not static
> /usr/src/linux-2.6/arch/alpha/include/asm/io.h:49: error:
> 'arch_local_irq_restore' is static but used in inline function '__set_hae'
> which is not static

A patch that fixes this was posted to linux-alpha some time ago (see
http://www.spinics.net/linux/lists/linux-alpha/msg00710.html).  I am not
sure why it hasn't made it through to Linus as yet.

Cheers
Michael.


