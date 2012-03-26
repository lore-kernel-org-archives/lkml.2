Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2CZVkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:40:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49549 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2CZVkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:40:18 -0400
Date: Mon, 26 Mar 2012 14:39:49 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v6 1/7] mm/memcg: scanning_global_lru means
 mem_cgroup_disabled
In-Reply-To: <20120326153131.GA22715@tiehlicka.suse.cz>
Message-ID: <alpine.LSU.2.00.1203261435110.3550@eggly.anvils>
References: <20120322214944.27814.42039.stgit@zurg> <20120322215616.27814.40563.stgit@zurg> <20120326150429.GA22754@tiehlicka.suse.cz> <20120326151815.GA1820@cmpxchg.org> <20120326153131.GA22715@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012, Michal Hocko wrote:
> 
> I guess that a note about changed ratio calculation should be added to
> the changelog.

To the changelog of a patch which changes the ratio calculation, yes; but
not to the changelog of this patch, which changes only the name of the test.

Hugh
