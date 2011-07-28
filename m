Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1G1HlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 03:41:12 -0400
Received: from lvk-gate.cmc.msu.ru ([212.192.248.233]:59130 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753384Ab1G1HlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 03:41:06 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 03:41:06 EDT
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt4
Date: Thu, 28 Jul 2011 11:33:06 +0400
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>, lasaine@lvk.cs.msu.su
References: <alpine.LFD.2.02.1107272222420.2660@ionos>
In-Reply-To: <alpine.LFD.2.02.1107272222420.2660@ionos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107281133.09107@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The list of disabled config option is now:
>
>  - CONFIG_HIGHMEM [ see the mess it created in 33-rt ]

Could someone please point me to information on this?

In our setup, we do use PREEMPT_RT + HIGHMEM, on .33 for now (but want to 
upgrade because of new hardware support issues with .33).  Up to now, we 
did not face any issues related to PREEMPT_RT + HIGHMEM combination.

Nikita
