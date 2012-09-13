Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2IMQrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:47:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:25471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455Ab2IMQrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,417,1344236400"; 
   d="scan'208";a="203129297"
Date: Thu, 13 Sep 2012 18:04:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?ISO-8859-1?B?SGr4bm5l?= =?ISO-8859-1?B?duVn?= 
	<arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH v7 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120913180457.1396637b@bob.linux.org.uk>
In-Reply-To: <20120913150133.GA16238@lizard>
References: <20120913150133.GA16238@lizard>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012 08:01:33 -0700
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> Hi all,
> 
> Here comes the lucky v7:
> 
> - Per Alan Cox's suggestion added hangup method and removed a small
>   leftover;
> - Per Colin Cross' suggestion moved IRQ quiescing logic into
>   poll_get_char routine. IIUC, Alan is less unhappy about it.  As a
>   result, clear_irq() callback dropped.

Ok that has my ack. Some of it is not pretty but debugger hooks that
have to run behind the OS while debugging it never are.

Acked-by: Alan Cox <alan@linux.intel.com>
