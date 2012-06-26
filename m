Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2FZH00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:26:26 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54328 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758372Ab2FZH0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:26:25 -0400
Message-ID: <4FE9637F.3050500@parallels.com>
Date: Tue, 26 Jun 2012 11:23:43 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to children
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-10-git-send-email-glommer@parallels.com> <20120625162352.51997c5a.akpm@linux-foundation.org> <alpine.DEB.2.00.1206252224350.30072@chino.kir.corp.google.com> <20120625223136.86ebee05.akpm@linux-foundation.org>
In-Reply-To: <20120625223136.86ebee05.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.9.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 09:31 AM, Andrew Morton wrote:
> On Mon, 25 Jun 2012 22:24:44 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
>
>>>> +#define KMEM_ACCOUNTED_THIS	0
>>>> +#define KMEM_ACCOUNTED_PARENT	1
>>>
>>> And then document the fields here.
>>>
>>
>> In hex, please?
>
> Well, they're bit numbers, not masks.  Decimal 0-31 is OK, or an enum.
>
enum it will be.



