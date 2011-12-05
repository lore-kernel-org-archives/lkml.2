Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1LESAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:00:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55711 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab1LESAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:00:02 -0500
Date: Mon, 5 Dec 2011 09:59:54 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/3] PM / Docs: Recommend the use of
 [un]lock_system_sleep() over mutex_[un]lock(&pm_mutex)
Message-ID: <20111205175954.GH627@google.com>
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com>
 <20111204200332.25620.53610.stgit@srivatsabhat.in.ibm.com>
 <20111205171508.GC627@google.com>
 <4EDD019E.9010009@linux.vnet.ibm.com>
 <20111205174349.GG627@google.com>
 <4EDD05C6.8080809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD05C6.8080809@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 11:26:22PM +0530, Srivatsa S. Bhat wrote:
> Yes, that sounds good. No need for giving unnecessary choices :-)
> But I had worded the documentation that way with the intention of
> explaining why calling mutex_lock() over pm_mutex can be disastrous (which
> I mentioned in the commit message as one of the goals of the patch).
> I didn't mean it to give the user 2 choices and say please use
> [un]lock_system_sleep() preferably.
> 
> Although, we have to notice that unless somebody is acquainted with
> these APIs, the first instinct would probably be to directly use
> mutex_lock(), until they look up the documentation (hopefully).
> So, IMHO, it would do good to keep the explanation in the docs as
> it is, in this patch. What do you think?

Yeah, sounds good to me.

Thanks.

-- 
tejun
