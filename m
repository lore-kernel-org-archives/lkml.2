Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2JCOJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:09:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37433 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab2JCOJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:09:44 -0400
Message-ID: <1349272974.2526.1.camel@falcor>
Subject: Re: [GIT] Security subsystem updates for 3.7
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 03 Oct 2012 10:02:54 -0400
In-Reply-To: <87lifn51pk.fsf@xmission.com>
References: <alpine.LRH.2.02.1210022124060.15182@tundra.namei.org>
	 <CA+55aFzfrzmOdJ-wQeSx5r-nin-J-tUCcyCGZ5xauF07UXL7cQ@mail.gmail.com>
	 <87lifn51pk.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12100314-5112-0000-0000-00000D093F2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 02:44 -0700, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Tue, Oct 2, 2012 at 4:35 AM, James Morris <jmorris@namei.org> wrote:
> >> Highlights:
> >>
> >> - Integrity: add local fs integrity verification to detect offline attacks
> >> - Integrity: add digital signature verification
> >
> > Ok, the integrity changes in particular clashed with the new user
> > namespace support by Eric Biederman.
> >
> > The clashes weren't all that big, but there have been semantic changes
> > in this area, and I'd like Eric to please check that I resolved it
> > correctly, and the integrity people to double-check my changes to the
> > "fowner" field.
> >
> > Mimi, Dmitry, Eric? Please check my current git tree, in particular
> > the security/integrity/ima/ima_policy.c file, but I think Eric should
> > look at the kernel/auditsc.c merge too, in case I missed something.
> 
> Those two resolutions look good to me.   Those were the resolutions
> I came up with in dealing with linux-next, so they have a modest amount
> of testing.

Thanks, the ima_policy.c changes look good to me too.

Mimi

> Elsewhere I have found issues in yama_lsm and drivers/staging/dgrp,
> patches after I have slept.
> 
> Eric
> 



