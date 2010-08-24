Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0HXAeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:34:05 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60058 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0HXAeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:34:02 -0400
Date: Tue, 24 Aug 2010 09:19:22 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH 4/5] memcg: lockless update of file_mapped
Message-Id: <20100824091922.ae133d72.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100824084916.078d6a82.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820190256.531af759.kamezawa.hiroyu@jp.fujitsu.com>
	<20100823175015.8d834645.nishimura@mxp.nes.nec.co.jp>
	<20100824084916.078d6a82.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 08:49:16 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 23 Aug 2010 17:50:15 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > This patch looks good to me, but I have one question.
> > 
> > Why do we need to acquire sc.lock inside mem_cgroup_(start|end)_move() ?
> > These functions doesn't access mc.*.
> > 
> 
> just reusing a lock to update status. If you don't like, I'll add a new lock.
> 
I see. I think it would be enough just to add some comments about it.


Thanks,
Daisuke Nishimura.
