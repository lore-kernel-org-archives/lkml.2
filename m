Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab2B2TgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:36:03 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46814 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567Ab2B2TgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:36:01 -0500
Date: Wed, 29 Feb 2012 20:35:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH next] memcg: remove PCG_FILE_MAPPED fix cosmetic fix
Message-ID: <20120229193555.GE1673@cmpxchg.org>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
 <alpine.LSU.2.00.1202282127110.4875@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1202282127110.4875@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 09:28:40PM -0800, Hugh Dickins wrote:
> mem_cgroup_move_account() begins with "anon = PageAnon(page)", and
> then anon is used thereafter: testing PageAnon(page) in the middle
> makes the reader wonder if there's some race to guard against - no.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
