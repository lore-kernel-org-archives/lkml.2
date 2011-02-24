Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1BXGx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:53:57 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62882 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab1BXGxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:53:54 -0500
Date: Thu, 24 Feb 2011 15:47:45 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: more mem_cgroup_uncharge batching
Message-Id: <20110224154745.b7d7a0ac.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <alpine.LSU.2.00.1102232139560.2239@sister.anvils>
References: <alpine.LSU.2.00.1102232139560.2239@sister.anvils>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 21:44:33 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> It seems odd that truncate_inode_pages_range(), called not only when
> truncating but also when evicting inodes, has mem_cgroup_uncharge_start
> and _end() batching in its second loop to clear up a few leftovers, but
> not in its first loop that does almost all the work: add them there too.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
Thank you catching this. This patch has already got enough ack's, but anyway:

	Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

P.S.
My address is "nishimura@mxp.nes.nec.co.jp", not "nishmura@mxp.nes.nec.co.jp" :)
