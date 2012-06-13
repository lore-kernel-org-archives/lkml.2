Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2FMVgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:36:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:42538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab2FMVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179658249"
Date: Wed, 13 Jun 2012 14:36:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
Message-ID: <20120613213651.GD32604@tassilo.jf.intel.com>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
 <1339615201-7456-2-git-send-email-andi@firstfloor.org>
 <1339622781.8980.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339622781.8980.63.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch is just wrong on too many levels.. where do you want me to
> start. Lets go with the restriction you mention is lifted, the SDM
> doesn't mention this, 

The SDM is wrong. The restriction is Sandy Bridge only.

>nor does the patch actually lift it.

Why not? It works for me on a Ivy Bridge.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
