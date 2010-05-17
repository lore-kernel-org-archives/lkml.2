Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0EQKej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:34:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53249 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0EQKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:34:37 -0400
Date: Mon, 17 May 2010 12:34:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] Fix boot_pageset sharing issue for new populated
	zones of hotadded nodes
Message-ID: <20100517103434.GC20761@basil.fritz.box>
References: <4BF0FBB0.1080707@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF0FBB0.1080707@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 04:17:52PM +0800, Haicheng Li wrote:
> In our recent cpu/memory hotadd testing, with multiple nodes hotadded,
> kernel easily panics under stress workload like kernel building.
>
> The root cause is that the new populated zones of hotadded nodes are
> sharing same per_cpu_pageset, i.e. boot strapping boot_pageset, which
> finally causes page state wrong.
>
> The following three patches will setup the pagesets for hotadded nodes
> with dynamically allocated per_cpu_pageset struct.

Patches look good, thanks.

-Andi
