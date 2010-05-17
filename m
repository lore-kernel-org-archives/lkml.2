Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0EQU0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:26:44 -0400
Received: from mga10.intel.com ([192.55.52.92]:4987 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754422Ab0EQU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,249,1272870000"; 
   d="scan'208";a="567984425"
Date: Mon, 17 May 2010 13:26:42 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 2/2] x86/mrst: add more timer config options
Message-ID: <20100517132642.000073d4@unknown>
In-Reply-To: <20100517125619.a0e123cd.randy.dunlap@oracle.com>
References: <1274124183-23431-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1274124183-23431-3-git-send-email-jacob.jun.pan@linux.intel.com>
	<20100517125619.a0e123cd.randy.dunlap@oracle.com>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap Mon, 17 May 2010 12:56:19 -0700

>> Manual override is possible via cmdline option x86_mrst_timer.
>
>which is documented where??
It is documented in Documentation/kernel-parameters.txt, the option has not changed but the impact has been extended to the new Medfield platforms.

        x86_mrst_timer= [X86-32,APBT]
                        Choose timer option for x86 Moorestown MID platform.
                        Two valid options are apbt timer only and lapic timer
                        plus one apbt timer for broadcast timer.
                        x86_mrst_timer=apbt_only | lapic_and_apbt


Thanks,

Jacob
