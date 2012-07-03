Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2GCEzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:55:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2GCEzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:55:53 -0400
MIME-Version: 1.0
In-Reply-To: <1341275894-9737-2-git-send-email-alex.page.kelly@gmail.com>
References: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
	<1341275894-9737-2-git-send-email-alex.page.kelly@gmail.com>
Date: Tue, 3 Jul 2012 12:55:52 +0800
Message-ID: <CAM_iQpVu6DV+LnTNbDUxUmjA+NXM2WCwWB0StCh+bwD5Gn_zbg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Made core dump functionality optional
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Alex Kelly <alex.page.kelly@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Josh Triplett <josh@joshtriplett.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, WANG Cong <amwang@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Nikhil Rao <ncrao@google.com>,
        Dan Ballard <dan@mindstab.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex <eshink@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 8:38 AM, Alex Kelly <alex.page.kelly@gmail.com> wrote:
> From: Alex <eshink@gmail.com>
>
> Adds an expert Kconfig option, CONFIG_COREDUMP, which allows disabling of core dump.
> This saves approximately 2.6k in the compiled kernel, and complements CONFIG_ELF_CORE,
> which now depends on it.
>
> CONFIG_COREDUMP also disables coredump-related sysctls, except for suid_dumpable and
> related functions, which are necessary for ptrace.
>
> Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Looks good, just one nitpick: would CONFIG_CORE_DUMP be better than
CONFIG_COREDUMP?

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
