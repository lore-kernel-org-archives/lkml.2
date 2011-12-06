Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1LFQfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:35:37 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64742 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1LFQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:35:35 -0500
Date: Tue, 6 Dec 2011 08:35:29 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, oleg@redhat.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/2] PM: Use the freezer_count() functions in
 [un]lock_system_sleep() APIs
Message-ID: <20111206163529.GB11747@google.com>
References: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com>
 <20111206160353.16729.91096.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206160353.16729.91096.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 09:34:02PM +0530, Srivatsa S. Bhat wrote:
> Now that freezer_count() and freezer_do_not_count() don't have the restriction
> that they are effective only when called by userspace processes, use
> them in lock_system_sleep() and unlock_system_sleep() instead of open-coding
> their parts.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
