Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0ELHU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:20:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0ELHU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:20:57 -0400
Message-ID: <4BEA56BE.1000905@kernel.org>
Date: Wed, 12 May 2010 09:20:30 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 2/5] stop_machine: reimplement using cpu_stop
References: <1273164772-19149-1-git-send-email-tj@kernel.org>	<1273164772-19149-3-git-send-email-tj@kernel.org> <20100511145059.d846e85c.akpm@linux-foundation.org>
In-Reply-To: <20100511145059.d846e85c.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 May 2010 07:20:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/11/2010 11:50 PM, Andrew Morton wrote:
> kernel/cpu.c: In function 'disable_nonboot_cpus':
> kernel/cpu.c:397: warning: 'error' may be used uninitialized in this function
> 
> Looks like this is a real bug if the cpumask happens to contain only a
> single CPU for some reason.

Indeed.  Hmm... I wonder why my builds didn't find it.

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
