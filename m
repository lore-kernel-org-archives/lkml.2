Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1GVTE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:04:57 -0400
Received: from mail.southpole.se ([193.12.106.18]:42507 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1GVTEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:04:55 -0400
Subject: Re: [PATCH 1/1] asm-generic: delay.h fix udelay and ndelay for 8
 bit args
From: Jonas Bonn <jonas@southpole.se>
To: sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1310997937-26771-1-git-send-email-jonas@southpole.se>
References: <1310986975.21015.13.camel@needafix>
	 <1310997937-26771-1-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Fri, 22 Jul 2011 21:04:52 +0200
Message-ID: <1311361492.2660.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2011-07-18 at 16:05 +0200, Jonas Bonn wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> With a non-constant 8-bit argument, a call to udelay() generates a warning:
> 
<snip>

> ---
> 
> Here's a patch that should resolve the merge conflict.  This applies
> Andrew's changes on top of the new asm-generic/delay.h instead of the x86
> arch-specific one.  I've tested this for OpenRISC and the changed macros
> don't cause any problems there.
> 
> Let me know if this is OK and I'll throw it into the OpenRISC tree together
> with the other delay.h modifications.
> 

I haven't gotten any feedback on this... since the change looks
appropriate to merge with the other changes to asm-generic/delay.h, I'll
apply this patch there and carry the patch together with the other
asm-generic/delay.h changes in the 'openrisc' tree.  Andrew can drop the
patch from his series to avoid the merge conflict.

I hope that works for everybody...

Thanks,
Jonas

