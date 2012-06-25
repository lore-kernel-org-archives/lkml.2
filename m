Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2FYNFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:05:43 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33230 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab2FYNFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:05:41 -0400
Message-ID: <4FE86188.6060700@parallels.com>
Date: Mon, 25 Jun 2012 17:03:04 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v4 06/25] memcg: Make it possible to use the stock for
 more than one page.
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-7-git-send-email-glommer@parallels.com> <20120620132804.GF5541@tiehlicka.suse.cz>
In-Reply-To: <20120620132804.GF5541@tiehlicka.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 05:28 PM, Michal Hocko wrote:
> I guess you want:
> 	if (nr_pages > CHARGE_BATCH)
> 		return false;
>
> because you don't want to try to use stock for THP pages.

Done, thanks.


