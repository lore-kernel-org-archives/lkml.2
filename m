Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1BIX7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:59:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57022 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab1BIX7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:59:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Feb 2011 08:53:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/4] memcg: convert uncharge batching from bytes to page
 granularity
Message-Id: <20110210085340.0b116b60.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297249313-23746-4-git-send-email-hannes@cmpxchg.org>
References: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
	<1297249313-23746-4-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 12:01:52 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> We never uncharge subpage quantities.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


