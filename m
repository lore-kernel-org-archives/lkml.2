Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2JXNp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:45:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:33057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab2JXNpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:45:55 -0400
Message-ID: <1351086300.23337.4.camel@twins>
Subject: Re: [RFC][PATCH] sched: Fix a deadlock of cpu-hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?=E9=99=88=E5=8D=8E=E6=89=8D?= <chenhc@lemote.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Date: Wed, 24 Oct 2012 15:45:00 +0200
In-Reply-To: <4259.58.209.249.125.1351082073.squirrel@mail.lemote.com>
References: <4259.58.209.249.125.1351082073.squirrel@mail.lemote.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 20:34 +0800, 陈华才 wrote:
> I see, this is an arch-specific bug, sorry for my carelessness and thank
> you for your tips. 

What arch are you using? And what exactly did the arch do wrong? Most of
the code involved seems to be common code.

Going by c0_compare_interrupt, this is some MIPS device.
