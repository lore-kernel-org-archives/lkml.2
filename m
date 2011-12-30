Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1L3PWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 10:22:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59966 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1L3PWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 10:22:45 -0500
Message-ID: <4EFDD740.5080303@gmail.com>
Date: Fri, 30 Dec 2011 09:22:40 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: convert to generic irq_domain
References: <1324099129-28832-1-git-send-email-robherring2@gmail.com> <20111219144940.GI20801@linutronix.de>
In-Reply-To: <20111219144940.GI20801@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On 12/19/2011 08:49 AM, Sebastian Andrzej Siewior wrote:
> * Rob Herring | 2011-12-16 23:18:49 [-0600]:
> 
>> This is needed to avoid struct collisions with the generic irq_domain
>> support being added to kernel/irq/generic-chip.c.
>>
>> Boot tested, but not on a DT enabled platform.
> 
> I had a patch in my tree for this and it did not work. One bug was fixed
> by eef24a ("irq: Fix check for already initialized irq_domain in
> irq_domain_add"). Something else come up after that. I will grab a board
> test it later and let you know :)
> 

Any update on testing this?

Rob
