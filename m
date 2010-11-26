Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0KZOTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:19:41 -0500
Received: from www.tglx.de ([62.245.132.106]:38231 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0KZOTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:19:40 -0500
Message-ID: <4CEFC1EC.7030507@linutronix.de>
Date: Fri, 26 Nov 2010 15:19:24 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Jon Loeliger <jdl@jdl.com>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 04/11] x86/dtb: add irq host abstraction
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-5-git-send-email-bigeasy@linutronix.de> <E1PLhWV-0004y7-44@jdl.com>
In-Reply-To: <E1PLhWV-0004y7-44@jdl.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Loeliger wrote:

>> +struct irq_host {
>> +	int (*xlate)(struct irq_host *h, const u32 *intspec, u32 intsize,
>> +			u32 *out_hwirq, u32 *out_type);
>> +	void *priv;
>> +	struct device_node *controller;
>> +	struct list_head l;
>> +};
> 
> I thought there was an intent and desire to rename the irq_host
> as irq_domain.
> 
> jdl

AFAIK Benh was thinking about renaming it. I don't know if this is still
the case or when he intends to do so. Once he does so, this can be renamed
as well.

Sebastian
