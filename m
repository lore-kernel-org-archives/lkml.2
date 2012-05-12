Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2ELL0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 07:26:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:58083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab2ELL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 07:26:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152128675"
Date: Sat, 12 May 2012 19:26:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: liwp.linux@gmail.com, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH] unmapped quotes
Message-ID: <20120512112637.GA11577@localhost>
References: <y>
 <4fae23ca.68db440a.4bc9.22cc@mx.google.com>
 <4FAE272C.6080804@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FAE272C.6080804@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 01:02:36PM +0400, Michael Tokarev wrote:
> On 12.05.2012 12:47, liwp.linux@gmail.com wrote:
> > - * If we're over `background_thresh' then the writeback threads are woken to
> > + * If we're over 'background_thresh' then the writeback threads are woken to
> 
> I can't say the original is wrong.  Since these quotes don't have
> "open" and "close" versions like {} or () pairs does, people often
> use ` as opening and ' as closing - while staying within ascii.
> Alternatives are things like « » or other things, but these aren't
> ascii anymore.  So I'd say keep it alone... ;)

Agreed. For example, latex uses ` and ' as opening and closing pairs.
That does look a bit weird for C and shell users ;)

Thanks,
Fengguang
