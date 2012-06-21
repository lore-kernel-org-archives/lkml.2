Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab2FUWjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:39:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48911 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab2FUWjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:39:23 -0400
Date: Fri, 22 Jun 2012 02:39:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/3] -tip cleanups/fixes for x2apic cluster mode
 routing
Message-ID: <20120621223918.GG24385@moon>
References: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 03:02:22PM -0700, Suresh Siddha wrote:
> Following patches will reserve the vector only on the cpu's where
> the interrupt will be routed to based on the specified affinity mask
> (not on the complete x2apic cluster which is the current behavior).
...

Great job, thanks Suresh!

	Cyrill
