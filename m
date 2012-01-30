Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2A3W1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:27:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64053 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2A3W1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:27:12 -0500
Date: Mon, 30 Jan 2012 14:27:08 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] PM/Freezer: Make thaw_processes() thaw only
 userspace tasks
Message-ID: <20120130222708.GD27616@google.com>
References: <20120130220259.9442.70091.stgit@srivatsabhat.in.ibm.com>
 <20120130220419.9442.39596.stgit@srivatsabhat.in.ibm.com>
 <20120130220919.GC27616@google.com>
 <4F271849.302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F271849.302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 03:53:05AM +0530, Srivatsa S. Bhat wrote:
> Yes, I was aware that it introduces such a window. But I ignored it in the
> interest of making the patch series sensible (as in, for example, patch
> 2/4 wouldn't make much sense without patch 1/4).
> Maybe I will interchange patch 1 and patch 2 and just reword the patch
> descriptions suitably so that they still make sense..

Yeah, I think saying sth like "Make extra calls to thaw_kthread in
preparation for blah blah.." should do.

Thanks.

-- 
tejun
