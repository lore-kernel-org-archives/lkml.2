Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab2HCEhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:37:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:40503 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2HCEhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:37:34 -0400
Date: Fri, 3 Aug 2012 14:37:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples/seccomp: fix endianness bug in LO_ARG define
In-Reply-To: <CAGXu5j+PAk4xbcr=3=O4qBD=+1++i1DeE=TX5S9vT3UivcR72w@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1208031437010.25196@tundra.namei.org>
References: <20120731141536.GA4262@osiris.boeblingen.de.ibm.com> <CAGXu5j+PAk4xbcr=3=O4qBD=+1++i1DeE=TX5S9vT3UivcR72w@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Kees Cook wrote:

> On Tue, Jul 31, 2012 at 7:15 AM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >
> > The LO_ARG define needs to consider endianness also for 32 bit builds.
> >
> > The "bpf_fancy" test case didn't work on s390 in 32 bit and compat mode
> > because the LO_ARG define resulted in a BPF program which read the upper
> > halve of the 64 bit system call arguments instead of the lower halves.
> >
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Good catch; thanks for the fix!
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
