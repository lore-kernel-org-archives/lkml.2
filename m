Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2FUXXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:23:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53917 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab2FUXXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:23:13 -0400
Message-ID: <4FE3ACCA.5000705@zytor.com>
Date: Thu, 21 Jun 2012 16:22:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com> <tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org> <20120621154334.05a74517.akpm@linux-foundation.org> <4FE3A495.1030008@zytor.com> <20120621155159.239aa972.akpm@linux-foundation.org> <4FE3A9DF.20303@zytor.com> <20120621161558.824d7c6b.akpm@linux-foundation.org> <20120621161842.9319cb99.akpm@linux-foundation.org>
In-Reply-To: <20120621161842.9319cb99.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 04:18 PM, Andrew Morton wrote:
>>
>> So why is ktime_t unsigned?
> 
> err, actually, it isn't.  But lots of the APIs to manipulate ktime_t
> use u64.  Reason?
> 
> I do agree that time quantities should be signed.

No idea... probably because when representing an actual wall time since
the POSIX epoch that can happen during the poweron time on the system,
the number will be positive since the POSIX epoch predates Linux.

	-hpa

