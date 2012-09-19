Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2ISHob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:44:31 -0400
Received: from mx2.parallels.com ([64.131.90.16]:52622 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab2ISHo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:44:29 -0400
Message-ID: <505976EA.6070104@parallels.com>
Date: Wed, 19 Sep 2012 11:40:26 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-16-git-send-email-glommer@parallels.com> <00000139da54937f-8f4add94-b203-4a6c-b99a-adc81d443b71-000000@email.amazonses.com>
In-Reply-To: <00000139da54937f-8f4add94-b203-4a6c-b99a-adc81d443b71-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 09:02 PM, Christoph Lameter wrote:
> Why doesnt slab need that too? It keeps a number of free pages on the per
> node lists until shrink is called.
> 
You have already given me this feedback, and I forgot to include it
here. I am sorry for this slip. It was my intention to this for the slab
as well.

Thanks for the eyes!




