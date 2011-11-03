Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab1KCHyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:54:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54903 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab1KCHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:54:05 -0400
Date: Thu, 3 Nov 2011 15:53:54 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111103075354.GA16666@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
 <20111020212353.GZ25124@google.com>
 <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
 <20111020213644.GB25124@google.com>
 <20111020230040.GC3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110210212130.12963@chino.kir.corp.google.com>
 <20111021094520.GA9884@zhy>
 <20111103071735.GA3228@swordfish.minsk.epam.com>
 <20111103072705.GA15871@zhy>
 <20111103074506.GB3228@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111103074506.GB3228@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 10:45:06AM +0300, Sergey Senozhatsky wrote:
> On (11/03/11 15:27), Yong Zhang wrote:
> > Did you have tried it? Though I don't find time to polish it yet but
> > I think will smooth your concern.
> > 
> 
> I'm compiling the kernel with you patch right now.
> The whole point was just for
> case if someone has different approach or whatsoever.

Understood. If someone can come up with a simple patch which could
cover the case I mentioned before, that would be great.
/me goes to poke at it.

Thanks,
Yong
