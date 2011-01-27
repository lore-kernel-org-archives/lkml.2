Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1A0TwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:52:07 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:42992 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1A0TwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:52:05 -0500
Subject: Re: [PATCH RESEND 0/4] Fix kconfig breakage wrt to CONFIGFS_FS
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Ingo Molnar <mingo@elte.hu>
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
In-Reply-To: <20110127194157.GA7565@elte.hu>
References: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
	 <20110127194157.GA7565@elte.hu>
Content-Type: text/plain
Date: Thu, 27 Jan 2011 11:52:01 -0800
Message-Id: <1296157921.14831.174.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 20:41 +0100, Ingo Molnar wrote:
> * Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi Linus,
> > 
> > The following four patches are to address recent Kconfig CONFIGFS_FS ->
> > 'select SYSFS' change for GFS2_FS, and 'depends && SYSFS && CONFIGFS_FS'
> > breakage for NETCONSOLE_DYNAMIC, DLM, and OCFS2_FS in .38-rc2.
> > 
> > Please review and consider pulling from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus-v2
> 
> I had the original for-linus branch tested rather extensively, and that one had no 
> problems. What's different in -v2?
> 

Hi Ingo,

The extra code is in patch #1 that fixes an additional GFS2_FS warning
reported by Randy that appeared after the initial CONFIGFS_FS -> 'select
SYSFS' conversion.

This patch for GFS2_FS was in scsi-post-merge-2.6.git/for-linus, but was
not included in the shortlog/stat to Linus.  So considering my current
(poor) record with Kconfig changes in mainline, I figured that sending
them out to the list one more time for review would make the most
sense.  ;)

Thanks,

--nab


