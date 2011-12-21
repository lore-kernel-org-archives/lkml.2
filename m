Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1LUMdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:33:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57178 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1LUMdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
	<tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
Date: Wed, 21 Dec 2011 20:33:16 +0800
Message-ID: <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Fix select_idle_sibling() regression in
 selecting an idle SMT sibling
From: alex shi <lkml.alex@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de, alex.shi@intel.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix it. Slightly bigger patch of cleaning all these goto's etc
> is queued up for the next release.
>

Even with this fix, the loopback netperf testing TCP-RR, still have
about 5% regresion on our 2 socket * 8 cores SNB machine.
which is your patchset includes all cleaning? wondering if that is helpful.
