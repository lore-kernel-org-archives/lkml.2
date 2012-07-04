Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2GDQxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:53:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2GDQxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:53:42 -0400
Subject: Re: [PATCH 5/5] perf/x86: Add Intel Nehalem-EX uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4FF46885.2090609@intel.com>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
	 <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
	 <1341396293.2507.77.camel@laptop>  <4FF46885.2090609@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 18:53:38 +0200
Message-ID: <1341420818.19870.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 00:00 +0800, Yan, Zheng wrote:
> 
> > Also, how can a single extra register require 192 bits of config space?
> > 
> Some events in the M-Box and R-Box require programming up to 3 extra
> registers. For example, the event 0x5 in the R-Box requires programming
> extra registers XBR_SET1_MM_CFG, XBR_SET1_MATCH and XBR_SET1_MATCH. 

But shouldn't you then use 3 extra_reg instead of blowing up the one?

