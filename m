Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1BQLF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:05:59 -0500
Received: from www.tglx.de ([62.245.132.106]:47744 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab1BQLFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:05:55 -0500
Date: Thu, 17 Feb 2011 12:05:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [sodaville] [PATCH TIP 02/14] x86: Add device tree support
Message-ID: <20110217110539.GA11260@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-3-git-send-email-bigeasy@linutronix.de> <20110124043427.GA20274@www.tglx.de> <20110216212746.GB22837@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110216212746.GB22837@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-02-16 14:27:46 [-0700]:

>> Andres, this patch moves some of the OF defines you added for OLPC from
>> irq.c to prom.c which requires CONFIG_X86_OF to be enabled. A later
>
>Why not simply make prom.c depend on CONFIG_OF?  There is no need to
>have an x86 specific config value for enabling devicetree code.

renamed it to CONFIG_OF

Sebastian
