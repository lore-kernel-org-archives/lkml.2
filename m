Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2F0QQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:16:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61507 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2F0QQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:16:51 -0400
MIME-Version: 1.0
In-Reply-To: <4FE9755B.1040905@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-3-git-send-email-glommer@parallels.com>
	<CABCjUKD0h089StLF8BwVRU-St70Ai9PTw-cjis40_aLLG3MAQQ@mail.gmail.com>
	<4FE9755B.1040905@parallels.com>
Date: Wed, 27 Jun 2012 09:16:51 -0700
Message-ID: <CABCjUKBJ9UewM=LePC89ZUdk4u4rnZXBNH43yN6qZhT8zcfieQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
From: Suleiman Souhlal <suleiman@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 1:39 AM, Glauber Costa <glommer@parallels.com> wrote:
> Yeah, forgot to update the changelog =(
>
> But much more importantly, are you still happy with those changes?

Yes, I am OK with those changes.

Thanks,
-- Suleiman
