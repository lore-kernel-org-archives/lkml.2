Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0JCA1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 20:27:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:36298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0JCA1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 20:27:37 -0400
Subject: Re: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq
 time -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Len Brown <len.brown@intel.com>
In-Reply-To: <AANLkTim4w6i0ASSbs_3PJvTQXxpDUcdRZz7c4A7_A6qv@mail.gmail.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	 <1285788096-29471-4-git-send-email-venki@google.com>
	 <1285844768.2144.11.camel@laptop>
	 <AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
	 <AANLkTikHfyjjZfDcoO-yDW+JTnpDb42VxRMckk55Xp+O@mail.gmail.com>
	 <1285933569.2144.57.camel@laptop>
	 <AANLkTinmgCmozNMQyesaTxrAfzgJ7bKEAeyNRWh7ceZ5@mail.gmail.com>
	 <AANLkTi=b2NaXOS05tT69hdmddxPPc5OxxnZ0qG0ZZZYe@mail.gmail.com>
	 <1285974873.2144.65.camel@laptop>
	 <AANLkTikcPX6m01F1rg--AKkSj_69kJJVsTrqB_FF6sJf@mail.gmail.com>
	 <1286016835.2144.86.camel@laptop>
	 <AANLkTim4w6i0ASSbs_3PJvTQXxpDUcdRZz7c4A7_A6qv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 03 Oct 2010 02:26:58 +0200
Message-ID: <1286065618.2144.104.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-02 at 08:26 -0700, Venkatesh Pallipadi wrote:
> Is it OK to use sched_clock() here until that time? I
> really want to get some wider testing feedback on this before spending
> more time. 

Sure.
