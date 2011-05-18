Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1ERKsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:48:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:56548 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab1ERKsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:48:04 -0400
Message-ID: <4DD3A3DE.40501@linutronix.de>
Date: Wed, 18 May 2011 12:47:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Torben Hohn <torbenh@linutronix.de>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH 1/2] x86/dtb: make irq host list accessible
References: <20110427143423.GB15211@linutronix.de> <20110429222600.GJ7497@ponder.secretlab.ca> <20110430090218.GA24750@linutronix.de> <20110502215936.GG10097@ponder.secretlab.ca>
In-Reply-To: <20110502215936.GG10097@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
>> This patch should be obsolete with of_irq_domain beeing generic now.
>> Could you please take look at the gpio driver? If there is nothing
>> obvious wrong I would rework it to work with of_irq_domain() and
>> repost.
> 
> okay, will do.

Ping :)

> g.

Sebastian
