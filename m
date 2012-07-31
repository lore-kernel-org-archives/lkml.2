Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2GaDxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 23:53:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53386 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2GaDxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 23:53:43 -0400
Message-ID: <501756A0.4080405@windriver.com>
Date: Mon, 30 Jul 2012 22:53:04 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>, <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 01/11] kernel/debug: Make use of KGDB_REASON_NMI
References: <20120730115719.GA5742@lizard> <1343649500-18491-1-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1343649500-18491-1-git-send-email-anton.vorontsov@linaro.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 06:58 AM, Anton Vorontsov wrote:
> Currently kernel never set KGDB_REASON_NMI. We do now, when we enter
> KGDB/KDB from an NMI.
>
> This is not to be confused with kgdb_nmicallback(), NMI callback is
> an entry for the slave CPUs during CPUs roundup, but REASON_NMI is the
> entry for the master CPU.

No need for confusion here :-)

I'll take this one for the kernel merge window if it passes regression tests, no reason not to be setting the stop codes properly.

Thanks,
Jason.

