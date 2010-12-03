Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab0LCOtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:49:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556Ab0LCOtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:49:06 -0500
Message-ID: <4CF90341.4020101@redhat.com>
Date: Fri, 03 Dec 2010 09:48:33 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: vatsa@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com>	 <20101202144423.3ad1908d@annuminas.surriel.com>	 <1291355656.7633.124.camel@marge.simson.net>	 <20101203134618.GG27994@linux.vnet.ibm.com> <1291387511.7992.15.camel@marge.simson.net>
In-Reply-To: <1291387511.7992.15.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 09:45 AM, Mike Galbraith wrote:

> I'll have to go back and re-read that.  Off the top of my head, I see no
> way it could matter which container the numbers live in as long as they
> keep advancing, and stay in the same runqueue.  (hm, task weights would
> have to be the same too or scaled. dangerous business, tinkering with
> vruntimes)

They're not necessarily in the same runqueue, the
VCPU that is given time might be on another CPU
than the one that was spinning on a lock.

-- 
All rights reversed
