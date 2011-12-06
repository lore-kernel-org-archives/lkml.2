Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1LFRZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:25:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1LFRZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:25:51 -0500
Date: Tue, 6 Dec 2011 18:20:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/2] PM / Freezer: Remove the "userspace only"
	constraint from freezer[_do_not]_count()
Message-ID: <20111206172020.GA709@redhat.com>
References: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Srivatsa S. Bhat wrote:
>
> And moreover, even the vfork issue does not need
> the above restriction in these functions, since they are anyway called by
> userspace processes.

This looks a bit confusing, as if CLONE_VFORK is not used by kthreads.
It is actually used, but only by the non-freezeable workqueue threads,
so the patch is fine.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

