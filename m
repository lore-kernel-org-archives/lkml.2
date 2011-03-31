Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab1CaA6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:58:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:9262 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab1CaA6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:58:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,271,1299484800"; 
   d="scan'208";a="903819598"
Date: Wed, 30 Mar 2011 17:56:27 -0700
From: Andi Kleen <ak@linux.intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110331005627.GD10173@tassilo.jf.intel.com>
References: <20110330144507.2c0ecf73.akpm@linux-foundation.org>
 <20110330233050.GG21838@one.firstfloor.org>
 <20110331095251.0EC3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331095251.0EC3.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 09:52:24AM +0900, KOSAKI Motohiro wrote:
> > > Do we still want it?  Are we sure we don't want the per-zone numbers?
> > 
> > At least I still want it and Dave Hansen did too.
> > 
> > I don't need per zone personally and I remember a strong request from 
> > anyone.  Or was there one?
> 
> If my remember is correct, Only /me puted weak request of per-zone number.
> To be honest, myself never use this counter, my question was just curious.
> Then, I'm ok if Andi didn't hit any issue.

Thanks

> Andi, But, if anyone will put numa request or numa related bug report 
> in future, Perhaps I might convert it per-zone one. Is this ok?

Sure. We can always change it later.

Andrew, this means you can merge it now I think.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
