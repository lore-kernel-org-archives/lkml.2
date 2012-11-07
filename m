Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2KGWxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:53:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2KGWxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:53:42 -0500
Date: Wed, 7 Nov 2012 14:53:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: oom: fix totalpages calculation for
 memory.swappiness==0
Message-Id: <20121107145340.b45a387c.akpm@linux-foundation.org>
In-Reply-To: <20121107224640.GE26382@dhcp22.suse.cz>
References: <20121011085038.GA29295@dhcp22.suse.cz>
	<1349945859-1350-1-git-send-email-mhocko@suse.cz>
	<20121015220354.GA11682@dhcp22.suse.cz>
	<20121107141025.2ac62206.akpm@linux-foundation.org>
	<20121107224640.GE26382@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012 23:46:40 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> > Realistically, is anyone likely to hurt from this?
> 
> The primary motivation for the fix was a real report by a customer.

Describe it please and I'll copy it to the changelog.

So that Greg can understand why we sent this at him and so that others
who hit the same problem (or any other problem!) will be able to
determine whether this patch might solve it.
