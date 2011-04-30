Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1D3JC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 05:02:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:60669 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1D3JCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 05:02:22 -0400
Date: Sat, 30 Apr 2011 11:02:18 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Torben Hohn <torbenh@linutronix.de>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH 1/2] x86/dtb: make irq host list accessible
Message-ID: <20110430090218.GA24750@linutronix.de>
References: <20110427143423.GB15211@linutronix.de>
 <20110429222600.GJ7497@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110429222600.GJ7497@ponder.secretlab.ca>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-04-29 16:26:00 [-0600]:

>On Wed, Apr 27, 2011 at 04:34:23PM +0200, Sebastian Andrzej Siewior wrote:
>> From: Torben Hohn <torbenh@linutronix.de>
>> 
>> There is an gpio irq chip comming which needs this from the outside.
>> There is no EXPORT_SYMBOL because this does not yet work in modules.
>> 
>Can you rework this to sit on top of the of_irq_domain series I sent
>out yesterday?  I *really* hope to get of_irq_domain merged into .40,
>but this change would conflict.

This patch should be obsolete with of_irq_domain beeing generic now.
Could you please take look at the gpio driver? If there is nothing
obvious wrong I would rework it to work with of_irq_domain() and
repost.

>Thanks,
>g.

Sebastian
