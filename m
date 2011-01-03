Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1ACSFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:05:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:15712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab1ACSFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:05:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,267,1291622400"; 
   d="scan'208";a="874033157"
Message-ID: <4D220FDB.4090000@linux.intel.com>
Date: Mon, 03 Jan 2011 10:05:15 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH 02/15] x86: Add device tree support
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>	<1292600033-12271-3-git-send-email-bigeasy@linutronix.de>	<20101230084311.GD11721@angua.secretlab.ca> <4D21BF17.6090209@linutronix.de>
In-Reply-To: <4D21BF17.6090209@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 04:20 AM, Sebastian Andrzej Siewior wrote:
> Grant Likely wrote:
>>> +extern char cmd_line[COMMAND_LINE_SIZE];
>>> +/* This number is used when no interrupt has been assigned */
>>> +#define NO_IRQ		(-1)
>>
>> 0 means NO_IRQ on x86 and most architectures.  I will change this when
>> I pick up the patch.
> 
> cat /proc/interrupts
>             CPU0
>    0:         40   IO-APIC-edge      timer
> 

0 for the timer is special.  However, Linus has declared that NO_IRQ is
to be zero, and that only very special interrupts like the PIT timer are
allowed to break that.

	-hpa
