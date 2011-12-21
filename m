Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1LUMwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:52:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:44970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1LUMwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:52:41 -0500
Message-ID: <1324471944.10752.8.camel@twins>
Subject: Re: [tip:sched/urgent] sched: Fix select_idle_sibling() regression
 in selecting an idle SMT sibling
From: Peter Zijlstra <peterz@infradead.org>
To: alex shi <lkml.alex@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, alex.shi@intel.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Date: Wed, 21 Dec 2011 13:52:24 +0100
In-Reply-To: <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
	 <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
	 <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 20:33 +0800, alex shi wrote:
> > Fix it. Slightly bigger patch of cleaning all these goto's etc
> > is queued up for the next release.
> >
> 
> Even with this fix, the loopback netperf testing TCP-RR, still have
> about 5% regresion on our 2 socket * 8 cores SNB machine.
> which is your patchset includes all cleaning? wondering if that is helpful.

Sorry, but that question fails to parse here. What were you asking?
