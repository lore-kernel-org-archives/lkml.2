Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1BIX54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:57:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55482 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1BIX5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:57:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Feb 2011 08:51:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/4] memcg: keep only one charge cancelling function
Message-Id: <20110210085145.9873fd18.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297249313-23746-2-git-send-email-hannes@cmpxchg.org>
References: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
	<1297249313-23746-2-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 12:01:50 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> We have two charge cancelling functions: one takes a page count, the
> other a page size.  The second one just divides the parameter by
> PAGE_SIZE and then calls the first one.  This is trivial, no need for
> an extra function.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


