Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936452Ab0COOUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:20:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:48905 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab0COOUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:20:17 -0400
Date: Mon, 15 Mar 2010 15:20:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Greg Thelen <gthelen@google.com>, Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix typo in refill_stock() comment
In-Reply-To: <20100311044526.GB17643@balbir.in.ibm.com>
Message-ID: <alpine.LNX.2.00.1003151519530.18642@pobox.suse.cz>
References: <1268255117-3280-1-git-send-email-gthelen@google.com> <20100311093226.8f361e38.nishimura@mxp.nes.nec.co.jp> <20100311044526.GB17643@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Balbir Singh wrote:

> > > Change refill_stock() comment: s/consumt_stock()/consume_stock()/
> > > 
> > > Signed-off-by: Greg Thelen <gthelen@google.com>
> > Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> >
> 
> Thanks for catching and fixing this.

I have picked that up into my queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
