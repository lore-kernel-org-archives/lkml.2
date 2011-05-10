Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1EJL0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:26:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35012 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab1EJL0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:26:42 -0400
Message-ID: <4DC92089.40305@ru.mvista.com>
Date: Tue, 10 May 2011 15:24:57 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tatyana Brokhman <tlinder@codeaurora.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 7/7] usb: Adding SuperSpeed support to dummy_hcd
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org> <1304853414-10234-8-git-send-email-tlinder@codeaurora.org> <20110509174910.GA7025@linutronix.de>
In-Reply-To: <20110509174910.GA7025@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-05-2011 21:49, Sebastian Andrzej Siewior wrote:

>> +
>> +	retval = usb_add_hcd(hs_hcd, 0, IRQF_DISABLED | IRQF_SHARED);

> Why IRQF_DISABLED | IRQF_SHARED? you don't interrupts at all.

    Moreover, IRQF_DISABLED is a nop now, see <linux/interrupt.h>.

WBR, Sergei
