Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0LATQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:16:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54396 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab0LATQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:16:00 -0500
Subject: Re: [tip:sched/core] sched: Do not account irq time to current task
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Raistlin <raistlin@linux.it>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTinv6M-aeNjUStMi05UDbi15ZvTKSu9N-hM63F7J@mail.gmail.com>
References: <1286237003-12406-7-git-send-email-venki@google.com>
	 <tip-305e6835e05513406fa12820e40e4a8ecb63743c@git.kernel.org>
	 <AANLkTin-U-kzr27ArR60K=eE5Jq+sPdTQ7JNhQg711c7@mail.gmail.com>
	 <1291031990.32004.24.camel@laptop> <20101129142213.GA2573@zhy>
	 <1291050395.2697.259.camel@Palantir>
	 <AANLkTikRh0mKkPY=m+kX47+5QNxE-hHSoRbQST3hnDUq@mail.gmail.com>
	 <AANLkTinv6M-aeNjUStMi05UDbi15ZvTKSu9N-hM63F7J@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 20:16:08 +0100
Message-ID: <1291230968.32004.1937.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 10:55 -0800, Venkatesh Pallipadi wrote:
> Peter: Can you pull that patchset into tip.

I'll try and have another look at those patches early next week. Do
remind me if you haven't heard back from me by Wednesday or something.


