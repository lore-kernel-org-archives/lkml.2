Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0LNOXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:23:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:53510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0LNOXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:23:05 -0500
Message-ID: <4D077DC2.8030905@kernel.org>
Date: Tue, 14 Dec 2010 15:22:58 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] workqueue: It is likely that WORKER_NOT_RUNNING
 is true
References: <1292287715.5015.1782.camel@gandalf.stny.rr.com>
In-Reply-To: <1292287715.5015.1782.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 14:23:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 01:48 AM, Steven Rostedt wrote:
> Hi Tejun,
> 
> You can either just take this patch out directly, or pull it from my
> repo.
> 
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: unlikely/workqueue
> 
> 
> Steven Rostedt (1):
>       workqueue: It is likely that WORKER_NOT_RUNNING is true

Cherry picked into wq#for-linus and sent pull request to Linus.

Thank you.

-- 
tejun
