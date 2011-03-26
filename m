Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1CZWsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 18:48:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56291 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1CZWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 18:48:40 -0400
Date: Sat, 26 Mar 2011 15:48:36 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Fasheh <mfasheh@suse.com>,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] fs,ocfs2: Move o2net_get_func_run_time under
 CONFIG_OCFS2_FS_STATS.
Message-ID: <20110326224836.GD8837@noexit>
Mail-Followup-To: Rakib Mullick <rakib.mullick@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Sunil Mushran <sunil.mushran@oracle.com>
References: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 05:01:08PM +0600, Rakib Mullick wrote:
> When CONFIG_DEBUG_FS=y and CONFIG_OCFS2_FS_STATS=n, we get the
> following warning:
> 
> fs/ocfs2/cluster/tcp.c:213:16: warning: ‘o2net_get_func_run_time’
> defined but not used
> 
> Since o2net_get_func_run_time is only called from
> o2net_update_recv_stats, so move it under CONFIG_OCFS2_FS_STATS.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

			http://www.jlbec.org/
			jlbec@evilplan.org
