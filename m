Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1FXT3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:29:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47669 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab1FXT3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:29:18 -0400
Date: Fri, 24 Jun 2011 12:29:03 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: yinghai@kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] PCI: fix cardbus and sriov regressions
Message-ID: <20110624192903.GM22917@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1308561849-3223-1-git-send-email-linuxram@us.ibm.com>
 <4DFFB6B0.6090307@hartkopp.net>
 <4DFFB945.5090203@hartkopp.net>
 <20110620214127.GA22917@ram-laptop>
 <4DFFC2FC.5050502@hartkopp.net>
 <4E0353CA.7000708@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0353CA.7000708@hartkopp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 04:55:06PM +0200, Oliver Hartkopp wrote:
> Hello RP,
> 
> unfortunately i noticed the discussion on linux-kernel ML a bit late, as i did
> not subscribe it due to the traffic.

sorry, did not see this mail earlier.


> >>> When comparing the logs with mgdiff, i found
> >>>
> >>> in revered:
> >>>
> >>> pci_bus 0000:04: resource 0 [io  0x2000-0x20ff]
> >>> pci_bus 0000:04: resource 1 [io  0x2400-0x24ff]
> >>>
> >>> in the fixed version (4 patches)
> >>>
> >>> pci_bus 0000:04: resource 0 [io  0x2400-0x24ff]
> >>> pci_bus 0000:04: resource 1 [io  0x2001-0x2100]
>
> Did you get further with the unusual alignment?

No. i was thinking this alignment  should be ok, since that cardbus resource
has to be SIZE aligned and not START aligned.

However if it is not acceptable, i will figure out a way
to get it aligned on the right boundaries.

RP
