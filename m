Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab2DAHZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:25:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab2DAHZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:25:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Sun, 1 Apr 2012 09:29:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Aaron Lu <aaron.lu@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <20120401055603.GA11505@localhost.amd.com> <1333263819.2387.94.camel@rui.sh.intel.com>
In-Reply-To: <1333263819.2387.94.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204010929.21234.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 01, 2012, Zhang Rui wrote:
[...]
> 
> How about this?
> 
> We should use the term "D3" in general in Linux.

I don't see why.  We can refer to the "old D3" as D3_cold.

> Without _PR3, OS should *assume* that the power is removed, although it
> may be not true.

That's correct.

> With _PR3, OS can *assure* that the power is removed, because it knows
> how to remove thw power (evaluating _PR3._OFF).

I'd rather say that with _PR3 we have the opportunity to avoid removing
power completely from the device.  In other words, D3_hot is supported (and
it is supported _only_ in that case).

> So the difference is that OS need to make sure whether to evaluate
> _PR3._OFF when _PR3 exists. For example, a device has _PR3, but _S0W
> returns 3, OS should not evaluate _PR3._OFF when the device sleeps with
> remote wakeup support.

That's correct.

> what do you think?

Well, see above and my other message in this thread.

Thanks,
Rafael
