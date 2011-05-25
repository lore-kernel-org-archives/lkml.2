Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1EYG6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:58:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:59598 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab1EYG6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:58:45 -0400
Date: Wed, 25 May 2011 08:58:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: KY Srinivasan <kys@microsoft.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481FCD99@TK5EX14MBXC122.redmond.corp.microsoft.com>
Message-ID: <alpine.LFD.2.02.1105250858110.3078@ionos>
References: <1306272773-4572-1-git-send-email-kys@microsoft.com> <alpine.LFD.2.02.1105250015360.3078@ionos> <6E21E5352C11B742B20C142EB499E0481FCD99@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, KY Srinivasan wrote:
> I like the idea of merging this code with some other file under arch/x86/.
> I could merge this code into mshyperv.c file that already has hyperv 
> specific code. Who would take this patch if I were to merge this 
> cleaned up Hyper-V clocksource code into mshyperv.c file under
> arch/X86/kernel/cpu.

x86 maintainers perhaps :)
