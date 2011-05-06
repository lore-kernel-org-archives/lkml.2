Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1EFEJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 00:09:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:63715 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab1EFEJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 00:09:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,324,1301900400"; 
   d="scan'208";a="688955678"
Date: Fri, 6 May 2011 12:09:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 00/17] writeback fixes and cleanups for 2.6.40
Message-ID: <20110506040914.GA20493@localhost>
References: <20110506030821.523093711@intel.com>
 <BANLkTimaf29+FDJV-6L3Jv5JQ9EvvOJrfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimaf29+FDJV-6L3Jv5JQ9EvvOJrfA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 12:06:42PM +0800, Anca Emanuel wrote:
> On Fri, May 6, 2011 at 6:08 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > The patches are also git pullable from
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git
> fs-writeback
> fatal: Couldn't find remote ref fs-writeback
> 
> 
> git ls-remote git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git
> 5895198c56d131cc696556a45f7ff0ea99ac297b	HEAD
> dbe30770c0b9d280742d3ef0c12b8187ce6e19a7	refs/heads/dirty-throttling-v2
> a56422a5103f57066e401e1d506f1e0cadbe3ad7	refs/heads/dirty-throttling-v3
> 1fe1fbdcbcd2bc1a0034ec84a927222b3278dca9	refs/heads/dirty-throttling-v4
> 6b7ca194675e2fb4aaf4394df3aedfda69ab14a4	refs/heads/dirty-throttling-v5
> 5f35306e8d2e56dd6973556a5b844e4eb8ce24c4	refs/heads/dirty-throttling-v6
> d0e30163e390d87387ec13e3b1c2168238c26793	refs/heads/dirty-throttling-v7
> 5895198c56d131cc696556a45f7ff0ea99ac297b	refs/heads/master
> ...
> 
> no branch fs-writeback.

It seems that it takes quite some time for the new branch to show up
publicly..

Thanks,
Fengguang
