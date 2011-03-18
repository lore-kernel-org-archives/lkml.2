Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1CRSbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:31:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:59707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1CRSbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:31:18 -0400
Date: Fri, 18 Mar 2011 11:31:15 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] fs,ocfs2: Move o2net_get_func_run_time under CONFIG_OCFS2_FS_STATS.
Message-ID: <20110318183115.GL1703@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
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
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Looks reasonable to me, thanks.
	--Mark

--
Mark Fasheh
