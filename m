Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2HWQVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:21:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49685 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2HWQVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:21:01 -0400
Date: Thu, 23 Aug 2012 18:20:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2012-08-13-16-55 uploaded
Message-ID: <20120823162050.GB19305@somewhere.redhat.com>
References: <20120813235651.00A13100047@wpzn3.hot.corp.google.com>
 <20120814105349.GA6905@dhcp22.suse.cz>
 <502A4410.6070201@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502A4410.6070201@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 04:26:56PM +0400, Glauber Costa wrote:
> On 08/14/2012 02:53 PM, Michal Hocko wrote:
> > On Mon 13-08-12 16:56:50, Andrew Morton wrote:
> >> > The mm-of-the-moment snapshot 2012-08-13-16-55 has been uploaded to
> >> > 
> >> >    http://www.ozlabs.org/~akpm/mmotm/
> > -mm git tree has been updated as well. You can find the tree at
> > https://github.com/mstsxfx/memcg-devel.git since-3.5
> > 
> > tagged as mmotm-2012-08-13-16-55
> > 
> 
> On top of this tree, people following the kmemcg development may also
> want to checkout
> 
>    git://github.com/glommer/linux.git memcg-3.5/kmemcg-stack
> 
> A branch called memcg-3.5/kmemcg-slab is also available with the slab
> changes ontop.

I tested it successfully to stop a forkbomb in a container.
One may need the following fix as well: http://marc.info/?l=linux-kernel&m=134573636430031&w=2

Andrew, others, what is your opinion on this patchset?

Thanks.
