Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2GCFJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 01:09:21 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33758 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2GCFJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 01:09:20 -0400
X-Originating-IP: 217.70.178.148
X-Originating-IP: 50.43.46.74
Date: Mon, 2 Jul 2012 22:09:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, WANG Cong <amwang@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Nikhil Rao <ncrao@google.com>,
        Dan Ballard <dan@mindstab.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex <eshink@gmail.com>
Subject: Re: [PATCH 2/2] Made core dump functionality optional
Message-ID: <20120703050908.GA14527@leaf>
References: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
 <1341275894-9737-2-git-send-email-alex.page.kelly@gmail.com>
 <CAM_iQpVu6DV+LnTNbDUxUmjA+NXM2WCwWB0StCh+bwD5Gn_zbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVu6DV+LnTNbDUxUmjA+NXM2WCwWB0StCh+bwD5Gn_zbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 12:55:52PM +0800, Cong Wang wrote:
> On Tue, Jul 3, 2012 at 8:38 AM, Alex Kelly <alex.page.kelly@gmail.com> wrote:
> > From: Alex <eshink@gmail.com>
> >
> > Adds an expert Kconfig option, CONFIG_COREDUMP, which allows disabling of core dump.
> > This saves approximately 2.6k in the compiled kernel, and complements CONFIG_ELF_CORE,
> > which now depends on it.
> >
> > CONFIG_COREDUMP also disables coredump-related sysctls, except for suid_dumpable and
> > related functions, which are necessary for ptrace.
> >
> > Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Looks good, just one nitpick: would CONFIG_CORE_DUMP be better than
> CONFIG_COREDUMP?

The kernel seems pretty split on that question, according to git grep;
"coredump" appears sufficiently often that changing the config option
name doesn't seem worth respinning the patch for.

- Josh Triplett
