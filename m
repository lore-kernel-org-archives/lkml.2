Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1JULfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:35:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57429 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1JULfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:35:54 -0400
Date: Fri, 21 Oct 2011 15:35:49 +0400
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
Message-ID: <20111021113549.GP14464@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <4EA15224.10102@parallels.com>
 <20111021112031.GO14464@moon>
 <4EA155A8.8010802@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA155A8.8010802@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 03:21:12PM +0400, Glauber Costa wrote:
...
> >>
> >
> >Glauber, could you please elaborate, you mean to call for forks inside
> >elf-chkpt handler, right? Or you mean something else?
> 
> not fork(), clone().
> 

I meant do_fork call. Anyway need to think about such approach, thanks!

	Cyrill
