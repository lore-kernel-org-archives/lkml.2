Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab1IORrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:47:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:12860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934241Ab1IORrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:47:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48855634"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sys_poll(): fix function definition/negative timeout values
References: <1316090761.6545.70.camel@localhost.localdomain>
Date: Thu, 15 Sep 2011 10:47:20 -0700
In-Reply-To: <1316090761.6545.70.camel@localhost.localdomain> (Thomas Meyer's
	message of "Thu, 15 Sep 2011 14:45:56 +0200")
Message-ID: <m27h59g0k7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> writes:

> Fix negative timeout values for x86 userland on x86_64 kernels.
> Align sys_poll() definition to glibc's definition.

Nack. Please write a compat wrapper that sign extends.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
