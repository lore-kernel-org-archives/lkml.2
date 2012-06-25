Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2FYWdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:33:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41216 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab2FYWdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <4FE8E632.70602@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-2-git-send-email-glommer@parallels.com>
	<20120625174437.GC3869@google.com>
	<4FE8E632.70602@parallels.com>
Date: Mon, 25 Jun 2012 15:33:01 -0700
X-Google-Sender-Auth: appXecS0QDnvzv4MDJrUQpYP7ts
Message-ID: <CAOS58YNV+uYbGYweSpQNSaRG8ixTG1ugTn42CfuAMO=S2ch6nw@mail.gmail.com>
Subject: Re: [PATCH 01/11] memcg: Make it possible to use the stock for more
 than one page.
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 25, 2012 at 3:29 PM, Glauber Costa <glommer@parallels.com> wrote:
>> It would be nice to explain why this is being done.  Just a simple
>> statement like - "prepare for XXX" or "will be needed by XXX".
>
>
> I picked this patch from Suleiman Souhlal, and tried to keep it as close as
> possible to his version.
>
> But for the sake of documentation, I can do that, yes.

Yeah, that would be great. Also, the patch does change behavior,
right? Explaining / justifying that a bit would be nice too.

Thanks!

-- 
tejun
