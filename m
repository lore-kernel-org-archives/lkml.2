Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1LERbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:31:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43296 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614Ab1LERbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:31:04 -0500
Date: Mon, 5 Dec 2011 09:30:57 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] PM / Sleep: Make [un]lock_system_sleep() generic
Message-ID: <20111205173057.GE627@google.com>
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com>
 <20111205171443.GB627@google.com>
 <4EDCFE9F.9050605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDCFE9F.9050605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Oleg)

On Mon, Dec 05, 2011 at 10:55:51PM +0530, Srivatsa S. Bhat wrote:
> I wanted these APIs to be generic, not restricted to work only for userspace
> processes. Both freezer_do_not_count() and freezer_count() are effective only
> when current->mm is non-NULL (ie., only for userspace ones).
> I think I have documented this in the patch which added these things to the
> 2 APIs. See commit 6a76b7a in linux-pm/linux-next.

I see.  Oleg was curious about the ->mm condition too and IIRC there's
no reason for that restriction.  Maybe removing that in another patch
and using the count functions is better?

Thanks.

-- 
tejun
