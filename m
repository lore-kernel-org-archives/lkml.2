Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2FNCQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:16:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:9051 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab2FNCQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:16:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165407160"
Date: Thu, 14 Jun 2012 10:16:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] writeback: Maintainer Record
Message-ID: <20120614021625.GA7021@localhost>
References: <1339633873-12729-1-git-send-email-liwp.linux@gmail.com>
 <1339635953.28729.8.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339635953.28729.8.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 06:05:53PM -0700, Joe Perches wrote:
> On Thu, 2012-06-14 at 08:31 +0800, Wanpeng Li wrote:
> >  MAINTAINERS |   10 ++++++++++
> []
> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > +WRITEBACK
> > +M:  Fengguang Wu <fengguang.wu@intel.com>
> 
> Generally the actual maintainer submits a patch
> to this file.
 
Hmm, I'd tend to not add this entry. For one thing, the git tag thing
looks silly. The dirty/writeback stuff in general involves both mm/fs,
and I'd like the relevant developers all keep an eye on this :-)

Thanks,
Fengguang

> Please use a single tab after each :
> 
> > +T:  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback
> > +S:  Maintained
> > +F:  include/linux/backing-dev.h
> > +F:  mm/backing-dev.c
> > +F:  include/linux/writeback.h
> > +F:  fs/fs-writeback.c
> > +F:  mm/page-writeback.c
> > +
> 
> 
