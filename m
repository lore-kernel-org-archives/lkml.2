Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3AAVIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:08:18 -0500
Received: from nm11.access.bullet.mail.mud.yahoo.com ([66.94.237.212]:37081
	"EHLO nm11.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3AAVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:08:16 -0500
X-Yahoo-Newman-Id: 360524.86237.bm@smtp107.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: PqPRPZ0VM1lPYfKLRLhsaDqMwSb9KOkff3AWTYiMJTn_ZaT
 vAMf1L_N.4InRn0_TpdgsWZSK541Kz5nu1HbKFGnA9HRh31Zk6pas94VSums
 YahjWXrUBlZhdgomHKCVDtW0wTrHHMhzJvzQQCAbC6.tGIbP.LijxznOdr3z
 QRM8lMVXa0Ps9x1FgNsg_7Rk40ydpqWEus8fpddYKLhEtutFpUz2kgMWNtTW
 4xioNW50KPyOq4L5EDKupLmhpwVFj15PbSql844iInjFZCzZtl_NvtvaKXH8
 .k7SApIxVwXGAyMsg8t3nNMQTEDwxTHvUEuOwm2NwEGvpdWPXZT9qsQx_7A5
 DiXA4phTJgvuc8ZxoOd3IqsTBOqRndg3bu.Xg_H83koHzuVXcmCk6NVId6qG
 SVhTC0QkwD4MTAsahrU4_gy.mpba_UhtHW.AtdmY5NcDAvS1Mujkg
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v7 0/9] Cleanup & new features for compiler*.h and bug.h
Date: Tue,  1 Jan 2013 15:08:02 -0600
Message-Id: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 include/linux/bug.h           |   47 ++++++++++++++++++++++------------------
 include/linux/compiler-gcc.h  |    3 ++
 include/linux/compiler-gcc3.h |    8 +++---
 include/linux/compiler-gcc4.h |   36 +++++++++++++++---------------
 include/linux/compiler.h      |   32 +++++++++++++++++++++++++--
 5 files changed, 80 insertions(+), 46 deletions(-)

This version just rebases against today's -next and with a slight modification
to CONFIG_ARCH_USE_BUILTIN_BSWAP code in in compiler-gcc4.h.

