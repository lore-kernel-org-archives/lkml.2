Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2DKJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:25:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:57697 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2DKJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:25:55 -0400
Date: Wed, 11 Apr 2012 11:25:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.4-rc2-rt1
In-Reply-To: <4F84C779.4080208@am.sony.com>
Message-ID: <alpine.LFD.2.02.1204111124560.2542@ionos>
References: <alpine.LFD.2.02.1204101642050.2542@ionos> <4F84C690.1010509@am.sony.com> <4F84C779.4080208@am.sony.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012, Frank Rowand wrote:
> [    0.253845]        CPU0                    CPU1
> [    0.253845]        ----                    ----
> [    0.253845]   lock(wakeupgen_lock.lock.wait_lock);

wakeupgen_lock wants to be raw. I'll fix it for -rt2

Thanks,

	tglx
