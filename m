Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2AXKE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:04:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:40641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2AXKE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:04:58 -0500
Subject: Re: [PATCH] sched/s390: fix compile error in sched/core.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4F1691FF.5010703@de.ibm.com>
References: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com>
	 <1326272868.2442.122.camel@twins>  <4F1691FF.5010703@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jan 2012 11:04:54 +0100
Message-ID: <1327399494.2614.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 10:33 +0100, Christian Borntraeger wrote:
> On 11/01/12 10:07, Peter Zijlstra wrote:
> 
> > Weird, I would have expected -next to pick this up.. Anyway, no
> > objection although do we really need that extra #ifdef ?
> 
> Ping.
> Do you want me to resubmit without ifdefs?

Drat, sorry for loosing this. Applied (and removed the ifdeffery
myself). Thanks!

