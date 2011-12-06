Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1LFQfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:35:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64742 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1LFQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:35:20 -0500
Date: Tue, 6 Dec 2011 08:35:10 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, oleg@redhat.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/2] PM / Freezer: Remove the "userspace only"
 constraint from freezer[_do_not]_count()
Message-ID: <20111206163510.GA11747@google.com>
References: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 09:33:44PM +0530, Srivatsa S. Bhat wrote:
> At present, the functions freezer_count() and freezer_do_not_count()
> impose the restriction that they are effective only for userspace processes.
> However, now, these functions have found more utility than originally
> intended by the commit which introduced it: ba96a0c8 (freezer:
> fix vfork problem). And moreover, even the vfork issue does not need
> the above restriction in these functions, since they are anyway called by
> userspace processes.
> 
> So, modify these functions to make them work even for kernel threads, so
> that they can be used at other places in the kernel, where the userspace
> restriction doesn't apply.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
