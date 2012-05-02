Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2EBPNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab2EBPNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:13:51 -0400
Message-ID: <4FA14F13.6040002@redhat.com>
Date: Wed, 02 May 2012 11:13:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/tlb_info: get last level TLB entry number of
 CPU
References: <1335603006-2572-2-git-send-email-alex.shi@intel.com>
In-Reply-To: <1335603006-2572-2-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 04:50 AM, Alex Shi wrote:
> For 4KB pages, x86 CPU has 2 or 1 level TLB, first level is data TLB and
> instruction TLB, second level is shared TLB for both data and instructions.
>
> For hupe page TLB, usually there is just one level and seperated by 2MB/4MB
> and 1GB.
>
> Although each levels TLB size is important for performance tuning, but for
> genernal and rude optimizing, just last level TLB entry number is suitable.
> And in fact, last level TLB has the biggest entry number.
>
> This patch will get the biggest TLB entry number and use it in furture TLB
> optimizing.
>
> Signed-off-by: Alex Shi<alex.shi@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

