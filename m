Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab2JABHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 21:07:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:4452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2JABHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 21:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="217116468"
Date: Sun, 30 Sep 2012 18:07:09 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tools: Add library dependencies for static perf
 link
Message-ID: <20121001010709.GB2628@tassilo.jf.intel.com>
References: <1348942428-29688-1-git-send-email-andi@firstfloor.org>
 <20120929185243.GB250@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120929185243.GB250@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is superfluous, because FLAGS_BFD has -ldl already by your change
> above. This is cascaded downwards.

I tried to remove it, but that makes it not link again for the static build.
Haven't looked into the causes.

-Andi
