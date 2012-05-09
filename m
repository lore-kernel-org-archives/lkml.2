Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab2EIMgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:36:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab2EIMgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:36:11 -0400
Message-ID: <4FAA64A7.6060203@redhat.com>
Date: Wed, 09 May 2012 14:35:51 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>  <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>  <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>  <1336566096.2527.30.camel@twins> <1336566178.2527.31.camel@twins>
In-Reply-To: <1336566178.2527.31.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 02:22 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-09 at 14:21 +0200, Peter Zijlstra wrote:
>> Does something like the below give any clues as to how we got there?
>
> I'm assuming you've got means of reproducing this?

Yep, it reproduces several times a day. I'll retest with your patch.

-- 
-----
  Igor
