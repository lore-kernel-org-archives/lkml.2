Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1KACL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 22:11:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39601 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1KACL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 22:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <CABeCy1Y_OXPJkca6dRvK4-PCfKH8wD_2Aq-9r-JyBBSCetrsOw@mail.gmail.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<CAGjg+kH577VE4cyq5zVNR962S6xbGCNnGS0w6N1DVuOppL3Khw@mail.gmail.com>
	<CABeCy1Y_OXPJkca6dRvK4-PCfKH8wD_2Aq-9r-JyBBSCetrsOw@mail.gmail.com>
Date: Tue, 1 Nov 2011 10:11:56 +0800
Message-ID: <CAGjg+kFyqWa=Ui+XRDoCvYFLt7eH-vScFk24tk1aZJkfWRMOxQ@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: alex shi <lkml.alex@gmail.com>
To: Venki Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>,
        alex shi <lkml.alex@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Alex,
>
> It should apply cleanly over 3.0. Thanks for testing the patch..

I tested the patch against 3.1 kernel for specpower benchmark on our
machine, westmere core laptop Thinkpad t410(internal name lkp-t410),
and on Romely-EP machine(lkp-sb03). No clear power or performance
change found. the performance and power has no clear change for every
level system load. from 0 to 100%.
