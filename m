Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2JYEoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:44:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42253 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2JYEoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:44:38 -0400
MIME-Version: 1.0
In-Reply-To: <5088C1BE.9010203@linux.intel.com>
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com>
	<1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<5086A3D1.7080709@linux.intel.com>
	<alpine.LFD.2.02.1210232138540.2756@ionos>
	<CAAHN_R0jTey+4TOXfKh96aApOPUXQq6wwobejmhFeRuTV2VJKA@mail.gmail.com>
	<alpine.LFD.2.02.1210242006450.2756@ionos>
	<5088C1BE.9010203@linux.intel.com>
Date: Thu, 25 Oct 2012 10:14:37 +0530
Message-ID: <CAAHN_R1QpjbBPxWiDHsKmHyqU9KLPPGFkMKmMWJCqsVk2AaUrw@mail.gmail.com>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if
 FUTEX_WAITERS is not set
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 10:06, Darren Hart <dvhart@linux.intel.com> wrote:
> Absolutely, that was great. Siddhesh, any objection to this test being
> incorporated into futextest?
>
> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary
>

I have no objection to the test being incorporated into futextest.

Thanks,
Siddhesh

-- 
http://siddhesh.in
