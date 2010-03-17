Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0CQOPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:15:35 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:16064 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548Ab0CQOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:15:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJx/oEtbss6F/2dsb2JhbACbA3S6MA2EaQQ
Date: Wed, 17 Mar 2010 15:15:28 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 0/4] RDC321x southbridge and GPIO support
Message-ID: <20100317141528.GB3823@infomag.iguana.be>
References: <201003110942.03602.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003110942.03602.florian@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

> Here are 4 patches relative to adding support for the RDC321x southbridge.
> This southbridge is present on all x86-based RDC321x System-on-a-Chip and
> provides access to GPIOs and Wathchdog. The watchdog driver is already merged.
> 
> Samuel, this is rebased on top of your mfd-2.6 master branch after commit 
> 522dba7 and I think the 4 patches should go via your tree to make sure the 
> merge is consistent.
> 
> Thank you.
> 
> Florian Fainelli (4):
>   x86: remove rdc321x_defs.h
>   MFD: add support for the RDC321x southbridge
>   GPIO: add support for RDC321x GPIO controller
>   WATCHDOG: convert rdc321x_wdt to use southbridge accessors

Watchdog part is OK for me. So Acked-by me can be added.
Personally I don't like the fact that you remove the rdc321x_defs.h file as the first patch.
If someone bisects the kernel, he will get a broken driver between the first and the fourth patch.

Kind regards,
Wim.

