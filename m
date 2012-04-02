Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2DBXA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:00:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:13079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab2DBXAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126305265"
Subject: Re: Don't apply 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 to stable
 please.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Mon, 02 Apr 2012 16:02:07 -0700
In-Reply-To: <20120402224701.GA6961@phenom.dumpdata.com>
References: <20120402224701.GA6961@phenom.dumpdata.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1333407728.1270.87.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 18:47 -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> The git commit 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 has CC stable@kernel.org
> but it breaks Xen - we are working to fix it in 3.4, but the fix for it
> does some architectual changes (136d249ef7dbf0fefa292082cc40be1ea864cbd6) that
> I don't know if you are comfortable putting in stable tree.

I am Ok if the commit '9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655' is not
applied to stable.

thanks,
suresh

