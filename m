Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1BCXwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:52:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54936 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1BCXwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:52:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 08:46:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: remove unused page flag bitfield defines
Message-Id: <20110204084625.b8c40f24.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110203141000.GE2286@cmpxchg.org>
References: <20110203141000.GE2286@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 15:10:00 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> These definitions have been unused since '4b3bde4 memcg: remove the
> overhead associated with the root cgroup'.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

I tried to remove this but finally I didn't. It seems there will be
no objections for this time.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

