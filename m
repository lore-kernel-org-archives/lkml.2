Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383Ab2C3T5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:57:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55976 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760601Ab2C3T47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:56:59 -0400
Date: Fri, 30 Mar 2012 23:56:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120330195652.GM1892@moon>
References: <20120328194312.GA22211@mail.hallyn.com>
 <20120328194613.GA3678@redhat.com>
 <20120328213044.GA26190@peqn>
 <20120328213736.GM2204@moon>
 <20120329023053.GA10187@mail.hallyn.com>
 <20120330123122.GB2024@moon>
 <20120330141219.GC3693@sergelap>
 <20120330144035.GC2024@moon>
 <20120330161500.GA32247@mail.hallyn.com>
 <CAGXu5jKjjvVUKeRM0_RQx7T-r74-v9PofPYUoGJYg1xmWcc2dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKjjvVUKeRM0_RQx7T-r74-v9PofPYUoGJYg1xmWcc2dQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:46:51PM -0700, Kees Cook wrote:
> >>
> >> I meant the dumper. Yes, at moment f_get/setown requires no privileges
> >> but I'm not sure if uid/euid is same or less sensible information
> >> than pid, that's why I though CAP_FOWNER might be worth to add, no?
> >
> > Hmm, I would say no, but that might be a good question for kees.
> >
> > IMO it's not sensitive information and so no sense requiring privilege
> > (and encouraging handing out of extra privilage to get at the info)
> 
> Nothing jumps out at me about just seeing uid/euid. Everything can be
> construed as an information leak, but this don't seem like something
> that needs special protection.

OK, thanks Kees.

	Cyrill
