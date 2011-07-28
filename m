Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1G1IpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:45:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:37111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1G1Io6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:44:58 -0400
Subject: Re: [ANNOUNCE] 3.0-rt4
From: Peter Zijlstra <peterz@infradead.org>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>, lasaine@lvk.cs.msu.su
In-Reply-To: <201107281224.44323@zigzag.lvk.cs.msu.su>
References: <alpine.LFD.2.02.1107272222420.2660@ionos>
	 <201107281133.09107@zigzag.lvk.cs.msu.su>
	 <alpine.LFD.2.02.1107280945080.2660@ionos>
	 <201107281224.44323@zigzag.lvk.cs.msu.su>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 28 Jul 2011 10:44:37 +0200
Message-ID: <1311842677.5890.209.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 12:24 +0400, Nikita V. Youshchenko wrote:
> 
> (*) we need >1G of memory for data buffers, and have too much legacy 
> software components so moving to 64bit system is not practical within 
> available resource 

You can run a complete 32bit userspace on a 64bit kernel without any
problems.
