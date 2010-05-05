Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab0EEJ4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:56:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:39060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934053Ab0EEJ4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:56:46 -0400
Message-ID: <4BE140C3.8020602@kernel.org>
Date: Wed, 05 May 2010 11:56:19 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu, efault@gmx.de,
       avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] perf: add perf_event_task_migrate()
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272976724-14312-4-git-send-email-tj@kernel.org>	 <20100505050846.GG5427@nowhere> <1273050684.1642.231.camel@laptop>	 <4BE13C76.2010507@kernel.org> <1273053025.1642.234.camel@laptop>
In-Reply-To: <1273053025.1642.234.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 09:56:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 11:50 AM, Peter Zijlstra wrote:
> I guess you can move it, I often end up adding tons of trace_printk()
> anyway when hunting funnies, might as well add one here when its
> relevant.

Great, will do so.

Thanks.

-- 
tejun
