Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1IPQid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:38:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:2689 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1IPQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:38:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="49206968"
Date: Fri, 16 Sep 2011 09:38:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Message-ID: <20110916163831.GA24876@tassilo.jf.intel.com>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <1316128013-21980-2-git-send-email-andi@firstfloor.org>
 <20110916154815.GA27150@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916154815.GA27150@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 11:48:15AM -0400, Christoph Hellwig wrote:
> On Thu, Sep 15, 2011 at 04:06:47PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Introduced by 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c
> 
> I think this should go to Chris/Linus ASAP.  But a slightly better
> patch description wouldn't hurt either.

Josef acked it earlier, but with a missing Chris the btrfs merge
pipeline seems to be disfunctional at the moment.

-Andi
