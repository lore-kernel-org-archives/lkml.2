Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544Ab0EEM3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:29:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:52681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0EEM3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:29:22 -0400
Message-ID: <4BE1648B.1080709@kernel.org>
Date: Wed, 05 May 2010 14:28:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu
CC: efault@gmx.de, avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org>	 <1273050400.1642.229.camel@laptop>  <4BE13B33.3030709@kernel.org>	 <1273053073.1642.235.camel@laptop>  <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop>
In-Reply-To: <1273059488.1642.245.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 12:29:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/05/2010 01:38 PM, Peter Zijlstra wrote:
> As it stands I'd argue to simply drop this whole idea. The SCHED_EVENT()
> thing doesn't look like its worth the obfuscation and I'm very much
> opposed to making perf and sched_notifiers rely on tracepoints.

Hmmm... okay.  Well, this thing is born out of Ingo's suggestion that
for more sched notifiers to be added notification mechanisms need to
be consolidated.  As long as I can get those two notifiers needed for
cmwq, it's okay with me.  Ingo, what do you think?

Thanks.

-- 
tejun
