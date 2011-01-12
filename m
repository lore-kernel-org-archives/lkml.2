Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab1ALAr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:47:28 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45213 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab1ALArY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:47:24 -0500
Date: Wed, 12 Jan 2011 09:38:14 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 1/2] memcg: remove unnecessary BUG_ON
Message-Id: <20110112093814.7ddc9fe7.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
References: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 17:51:11 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Now memcg in unmap_and_move checks BUG_ON of charge.
> mem_cgroup_prepare_migration returns either 0 or -ENOMEM.
> If it returns -ENOMEM, it jumps out unlock without the check.
> If it returns 0, it can pass BUG_ON. So it's meaningless.
> Let's remove it.
> 
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
