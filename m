Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1A0TmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:42:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1A0TmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:42:23 -0500
Date: Thu, 27 Jan 2011 20:41:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND 0/4] Fix kconfig breakage wrt to CONFIGFS_FS
Message-ID: <20110127194157.GA7565@elte.hu>
References: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi Linus,
> 
> The following four patches are to address recent Kconfig CONFIGFS_FS ->
> 'select SYSFS' change for GFS2_FS, and 'depends && SYSFS && CONFIGFS_FS'
> breakage for NETCONSOLE_DYNAMIC, DLM, and OCFS2_FS in .38-rc2.
> 
> Please review and consider pulling from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus-v2

I had the original for-linus branch tested rather extensively, and that one had no 
problems. What's different in -v2?

Thanks,

	Ingo
