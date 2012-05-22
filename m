Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2EVRpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:45:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45234 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2EVRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:45:37 -0400
Date: Tue, 22 May 2012 21:45:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, agordeev@redhat.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/2] x2apic, cluster: use all the members of one cluster
 specified in the smp_affinity mask for the interrupt desintation
Message-ID: <20120522174532.GD1442@moon>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
 <20120522070428.GA15738@gmail.com>
 <1337707275.1997.184.camel@sbsiddha-desk.sc.intel.com>
 <20120522173922.GC1442@moon>
 <1337708577.1997.187.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337708577.1997.187.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:42:57AM -0700, Suresh Siddha wrote:
> > x2apic, or the way it resturns apicid now was done by a purpose?
> 
> Don't know. Those are very old platforms. Not worth tuning them IMHO.

I see,thanks.

	Cyrill
