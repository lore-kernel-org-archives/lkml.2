Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab2DAGmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 02:42:20 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:13724
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab2DAGmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 02:42:17 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1SFYD-01-1TV-02
X-M-MSG: 
Date: Sun, 1 Apr 2012 22:41:25 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Len Brown <lenb@kernel.org>, "Rafeal J. Wysocki" <rjw@sisk.pl>,
        <linux-acpi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Message-ID: <20120401144125.GA2900@localhost.amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
 <1333258053.2939.22.camel@minggr>
 <20120401055603.GA11505@localhost.amd.com>
 <1333261737.2939.84.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333261737.2939.84.camel@minggr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Apr 2012 06:42:07.0287 (UTC) FILETIME=[8E8E9470:01CD0FD2]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 02:28:57PM +0800, Lin Ming wrote:
> > 
> > There is no D3 hot support for this device(from the firmware's
> > perspective), either it is at D0(via _PS0), or it will be at D3 cold(via
> > _PS3).
> 
> But this is the generic code. We can't only consider some special
> device.
Agree.

The code change I've made only affects D3 cold path, existing code path
to set device power state to D0-D3hot is not affected.

And for D3 cold path, I don't think evaluating _PS3 should do any harm
to the device, isn't it the case?

> 
> Maybe we need some flag to tell which D3 state _PS3 is used for.
Do you mean the ACPI spec needs to be updated to reflect which D3
state the device will be at once its _PS3 is evaluated?

-Aaron

