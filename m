Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1JTQEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:04:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64938 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1JTQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:04:44 -0400
Date: Thu, 20 Oct 2011 20:04:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
Message-ID: <20111020160437.GH14464@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <20111014173304.GD4294@google.com>
 <4E9E9255.7090601@parallels.com>
 <20111019182228.GJ25124@google.com>
 <4E9FDCEF.5050008@parallels.com>
 <20111020155645.GV25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020155645.GV25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 08:56:45AM -0700, Tejun Heo wrote:
...
> 
> > > IMHO, this is a fundamentally broken approach which isn't even
> > > necessary.  So, FWIW, NACK.
> > 
> > It's a pity :( Anyway, as I stated above, we'll try to compare two
> > real implementations, not abstract assumptions.
> 
> Given the state of this thread, I'm pretty skeptical this one can
> survive but, hey, who knows?
> 

Nope, if it eventually appear to be better -- there will be no point
to continue keeping elfism, and back, if it end up in bunch of levers
are to be injected into kernel, then definitely tuning up elf more
will be a winner. It's development process after all :) I'm working
on seized-restore atm, once I have something to show -- will ping you.

	Cyrill
