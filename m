Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2IFM2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:28:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:62467 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab2IFM2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,380,1344236400"; 
   d="scan'208";a="189602465"
Date: Thu, 6 Sep 2012 05:28:50 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, bp@amd64.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, ananth@in.ibm.com
Subject: Re: [PATCH] [mcelog] Start using the new sysfs tunables location
Message-ID: <20120906122850.GI17289@tassilo.jf.intel.com>
References: <20120905102156.9423.27806.stgit@localhost.localdomain>
 <20120905103237.9726.56131.stgit@localhost.localdomain>
 <20120905184708.GC16230@one.firstfloor.org>
 <CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The change is still under discussion. Stage one is to add the new global
> pathnames in addition to keeping the old per-cpu ones. Also fix all utilities
> (just mcelog(8) as far as we know) to prefer the new paths.

But why do you even want to change it?  Does it fix anything?
AFAIK the old setup -- while not being pretty -- works just fine.

-Andi
