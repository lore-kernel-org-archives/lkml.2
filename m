Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2HNMaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:30:03 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51677 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab2HNMaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:30:00 -0400
Message-ID: <502A4410.6070201@parallels.com>
Date: Tue, 14 Aug 2012 16:26:56 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: mmotm 2012-08-13-16-55 uploaded
References: <20120813235651.00A13100047@wpzn3.hot.corp.google.com> <20120814105349.GA6905@dhcp22.suse.cz>
In-Reply-To: <20120814105349.GA6905@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 02:53 PM, Michal Hocko wrote:
> On Mon 13-08-12 16:56:50, Andrew Morton wrote:
>> > The mm-of-the-moment snapshot 2012-08-13-16-55 has been uploaded to
>> > 
>> >    http://www.ozlabs.org/~akpm/mmotm/
> -mm git tree has been updated as well. You can find the tree at
> https://github.com/mstsxfx/memcg-devel.git since-3.5
> 
> tagged as mmotm-2012-08-13-16-55
> 

On top of this tree, people following the kmemcg development may also
want to checkout

   git://github.com/glommer/linux.git memcg-3.5/kmemcg-stack

A branch called memcg-3.5/kmemcg-slab is also available with the slab
changes ontop.

Thanks.
