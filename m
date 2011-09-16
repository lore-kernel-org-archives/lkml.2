Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1IPSM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:12:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1IPSMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:12:55 -0400
Date: Fri, 16 Sep 2011 22:11:46 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm00@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Kirill Shutemov <kirill@shutemov.name>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v12
Message-ID: <20110916181146.GA20801@albatros>
References: <20110914144841.GA7906@albatros>
 <20110914160018.GW25367@sun>
 <20110914160724.GA10612@albatros>
 <20110915091417.GA27755@sun>
 <20110915092757.GA23404@albatros>
 <20110915102922.GB27755@sun>
 <20110915105651.GA17575@albatros>
 <20110915201939.GE12040@sun>
 <20110916175618.GA20046@albatros>
 <20110916180731.GB8599@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916180731.GB8599@sun>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 22:07 +0400, Cyrill Gorcunov wrote:
> > BTW, not a big deal, but probably you should return -EACCES on
> > !capable() as file presence is not an issue in this case.
> > 
> >     if (!ptrace_may_access(task, PTRACE_MODE_READ))
> >         goto out_notask;
> > 
> >     status = -EACCES;
> >     if (!capable(CAP_SYS_ADMIN))
> >         goto out_notask;
> > 
> >     status = 0;
> > 
> > 
> 
> That's not a proble to fix it actually. So can I fix it and
> put some tage here (Reviewed or something?).

Yep, with CAP_SYS_ADMIN check there should be no issues here.

Reviewed-by: Vasiliy Kulikov <segoon@openwall.com>

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
