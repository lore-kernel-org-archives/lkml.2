Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2JPAyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:54:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64035 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2JPAyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:54:39 -0400
Date: Mon, 15 Oct 2012 17:54:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: describe memcg swappiness more precisely
 memory.swappiness==0
In-Reply-To: <20121015220725.GB11682@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1210151754220.31712@chino.kir.corp.google.com>
References: <20121011085038.GA29295@dhcp22.suse.cz> <1349945859-1350-1-git-send-email-mhocko@suse.cz> <20121015220354.GA11682@dhcp22.suse.cz> <20121015220725.GB11682@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Michal Hocko wrote:

> And a follow up for memcg.swappiness documentation which is more
> specific about spwappiness==0 meaning.
> ---
> From 1bc3a94fea728107ed108edd42df464b908cd067 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 15 Oct 2012 11:43:56 +0200
> Subject: [PATCH] doc: describe memcg swappiness more precisely
> 
> since fe35004f (mm: avoid swapping out with swappiness==0) memcg reclaim
> stopped swapping out anon pages completely when 0 value is used.
> Although this is somehow expected it hasn't been done for a really long
> time this way and so it is probably better to be explicit about the
> effect. Moreover global reclaim swapps out even when swappiness is 0
> to prevent from OOM killer.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>
