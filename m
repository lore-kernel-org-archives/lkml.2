Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2BHJoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:44:08 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37533 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2BHJoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:44:06 -0500
Message-ID: <4F3243D4.4080907@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 15:13:48 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Use case for PERF_COUNT_HW_REF_CPU_CYCLES generic PMU event
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020723-5140-0000-0000-000000B774F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephane, 

I was going through the following discussion where we added the
new HW generic event PERF_COUNT_HW_REF_CPU_CYCLES.

https://lkml.org/lkml/2011/12/10/103 

(Sorry, for asking this question bit late)

I am trying to understand the use case for this. Would this new event
help us in generating (during a perf session) a CPU frequency invariant
time metric against which we would plot our other perf event's measurements ?
CPU frequency independent time measurement is it's primary purpose ? or we were
finding a way to expose the fixed counter 2 which was not getting used before 
for not having an event encoding. I guess this would help us in finding equivalent
PMU events or mechanisms in other architecture / platforms.

-- 
Anshuman Khandual
Linux Technology Centre
IBM Systems and Technology Group

