Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1JULUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:20:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42136 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1JULUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:20:37 -0400
Date: Fri, 21 Oct 2011 15:20:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
Message-ID: <20111021112031.GO14464@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <4EA15224.10102@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA15224.10102@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 03:06:12PM +0400, Glauber Costa wrote:
...
> exec() is a fundamental interface to the kernel, and the change
> proposed here is too disruptive. Not only that, it is rather
> unannounced: since not always one knows kind of fmt file is being
> exec'd, it gets hard to infer which behavior to expect.
> 

This missed snipped in changelog indeed my very fault, sorry for that.

> I am wondering, though: if exec is a problem, but the binary handler
> is not, maybe we can exec a process using this handler, and then
> have the handler itself to create the thread hierarchy. This way we
> avoid changing exec() behavior at all, yet achieving the same
> results.
> 
> What do you think?
> 
> 

Glauber, could you please elaborate, you mean to call for forks inside
elf-chkpt handler, right? Or you mean something else?

	Cyrill
