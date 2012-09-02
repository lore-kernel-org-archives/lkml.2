Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2IBHhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:37:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2IBHhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:37:52 -0400
Date: Sun, 2 Sep 2012 09:37:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@parisplace.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] security: unconditionally call Yama
In-Reply-To: <CAGXu5jKD0MDetYuavSmXjDB3t3cYEkiEoEY-bAMyhFrmTaA6FA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1209020935390.20709@pobox.suse.cz>
References: <20120831213126.GA19688@www.outflux.net> <20120831223908.4aa5574d@pyramind.ukuu.org.uk> <CACLa4pv75-HaPEas=aOMySbMm-YdSJZdc6qtNUnTM+Ev2Rp7rg@mail.gmail.com> <87ipbyfw9j.fsf@xmission.com> <CACLa4ptpGJ7YDTqmOvtHq_Ts9f72SBV6Q_HDDw1OebhxVOzU9w@mail.gmail.com>
 <87627ye7vh.fsf@xmission.com> <CAGXu5jKD0MDetYuavSmXjDB3t3cYEkiEoEY-bAMyhFrmTaA6FA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2012, Kees Cook wrote:

> Given that several distros use (or want to use) Yama, I think that's 
> reason enough for this. I think it's important for us to take a 
> practical approach here, and having the big LSMs each hook Yama instead 
> of doing this in a single global place will make it needlessly 
> duplicated code.

With my SUSE hat on, I would be really reluctant to enable config option 
in the distribution kernel that will make attaching gdb to running 
processess impossible without any further tuning (like sysctl/procfs knob 
to explicitly enable this feature).

Thanks,

-- 
Jiri Kosina
SUSE Labs
