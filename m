Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0KZLSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:18:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60734 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0KZLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:18:23 -0500
Date: Fri, 26 Nov 2010 11:18:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
Message-ID: <20101126111806.GJ9310@n2100.arm.linux.org.uk>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <4CE821BF.7030009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE821BF.7030009@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 09:30:07PM +0200, Paulius Zaleckas wrote:
>> +#include<linux/kernel.h>
>> +#include<linux/pci.h>
>> +#include<linux/irq.h>
>> +
>> +#include<asm/mach/pci.h>
>> +#include<asm/gpio.h>

linux/gpio.h, not asm/gpio.h please.
