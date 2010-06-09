Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0FISqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:46:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34258 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab0FISqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:46:46 -0400
Message-ID: <4C0FE17B.10108@zytor.com>
Date: Wed, 09 Jun 2010 11:46:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       linuxppc-dev@lists.ozlabs.org, roland@redhat.com, arnd@arndb.de
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
References: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com> <20100601193230.GA17579@us.ibm.com> <AANLkTinxCKl7RVe62UhIpNe5EriCufkgaih2D2mLLmC4@mail.gmail.com> <20100602013839.GB17579@us.ibm.com> <AANLkTinFGblE4fW35O0LchJZ22tz_5-qervpGC_lpUj_@mail.gmail.com> <20100609181431.GB1211@us.ibm.com>
In-Reply-To: <20100609181431.GB1211@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 11:14 AM, Sukadev Bhattiprolu wrote:
> | 
> | Even for x86, it's an easier API. Callers would be specifying
> | two numbers they already have: the argument and return value
> | for malloc. Currently the numbers must be added together,
> | destroying information, except on hppa (must not add size)
> | and ia64 (must use what I'm proposing already).
> 
> I agree its easier and would avoid #ifdefs in the applications.
> 
> Peter, Arnd, Roland - do you have any concerns with requiring all
> architectures to specify the stack to eclone() as [base, offset]
> 

Makes sense to me.  There might be advantages to be able to track the
size of the "stack allocation" even for other architectures, too.

	-hpa
