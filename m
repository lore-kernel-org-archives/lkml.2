Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab0KPDtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:49:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40097 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0KPDts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:49:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 12:44:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] memcg: use native word page statistics counters
Message-Id: <20101116124414.98167f7c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101107220353.964566018@cmpxchg.org>
References: <20101107215030.007259800@cmpxchg.org>
	<20101107220353.964566018@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Nov 2010 23:14:39 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The statistic counters are in units of pages, there is no reason to
> make them 64-bit wide on 32-bit machines.
> 
> Make them native words.  Since they are signed, this leaves 31 bit on
> 32-bit machines, which can represent roughly 8TB assuming a page size
> of 4k.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

