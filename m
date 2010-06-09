Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab0FIWdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab0FIWdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:33:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       linuxppc-dev@lists.ozlabs.org, hpa@zytor.com, arnd@arndb.de
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
In-Reply-To: Sukadev Bhattiprolu's message of  Wednesday, 9 June 2010 11:14:31 -0700 <20100609181431.GB1211@us.ibm.com>
References: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com>
	<20100601193230.GA17579@us.ibm.com>
	<AANLkTinxCKl7RVe62UhIpNe5EriCufkgaih2D2mLLmC4@mail.gmail.com>
	<20100602013839.GB17579@us.ibm.com>
	<AANLkTinFGblE4fW35O0LchJZ22tz_5-qervpGC_lpUj_@mail.gmail.com>
	<20100609181431.GB1211@us.ibm.com>
X-Zippy-Says: My LESLIE GORE record is BROKEN..
Message-Id: <20100609223249.AC8204B2CC@magilla.sf.frob.com>
Date: Wed,  9 Jun 2010 15:32:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter, Arnd, Roland - do you have any concerns with requiring all
> architectures to specify the stack to eclone() as [base, offset]

I can't see why that would be a problem.  
It's consistent with the sigaltstack interface we already have.


Thanks,
Roland
