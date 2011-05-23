Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1EWNvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:51:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:59421 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1EWNvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:51:41 -0400
Date: Mon, 23 May 2011 15:51:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: KY Srinivasan <kys@microsoft.com>
cc: Christoph Hellwig <hch@infradead.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: vmbus driver
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481FC6DF@TK5EX14MBXC122.redmond.corp.microsoft.com>
Message-ID: <alpine.LFD.2.02.1105231550360.3078@ionos>
References: <1305842785-30206-1-git-send-email-kys@microsoft.com> <20110520122649.GA550@infradead.org> <6E21E5352C11B742B20C142EB499E0481FC2ED@TK5EX14MBXC122.redmond.corp.microsoft.com> <20110522105941.GB8346@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481FC6DF@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, KY Srinivasan wrote:
> I am working on getting Hyper-V drivers (drivers/staging/hv/*) out of staging.
> I would like to request you to look at the Hyper-V timesource driver:
> drivers/staging/hv/hv_timesource.c. The supporting code for this driver
> is already part of the base kernel. Let me know if this driver is ready to exit staging.

Can you please send a patch against drivers/clocksource (the staging
part is uninteresting for review).

Thanks,

	tglx
