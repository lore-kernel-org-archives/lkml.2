Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2BGSIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:08:09 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:29107 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2BGSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:08:07 -0500
Message-ID: <4F316848.4060100@atmel.com>
Date: Tue, 07 Feb 2012 19:07:04 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 24/25] irq_domain: remove "hint" when allocating irq
 numbers
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <1327700179-17454-25-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327700179-17454-25-git-send-email-grant.likely@secretlab.ca>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 10:36 PM, Grant Likely :
> The 'hint' used to try and line up irq numbers with hw irq numbers is
> rather a hack and not very useful.  Now that /proc/interrupts also outputs
> the hwirq number, it is even less useful to keep around the 'hint' heuristic.
> 
> This patch removes it.

Grant,

While trying your patch series in conjunction with Rob one, I do not
find this patch in your irqdomain/next branch (and a couple of others).
Can you tell me if this v3 series is available as a git tree?

Thanks, best regards,
-- 
Nicolas Ferre
