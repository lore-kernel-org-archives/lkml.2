Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1BWUvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:51:11 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44738 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1BWUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:51:10 -0500
Message-ID: <4D6572ED.9020805@mvista.com>
Date: Wed, 23 Feb 2011 23:49:49 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Pratheesh Gangadhar <pratheesh@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, amit.chatterjee@ti.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, hjk@hansjkoch.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] PRUSS UIO driver support
References: <1298469161-7644-1-git-send-email-pratheesh@ti.com>	<1298469161-7644-2-git-send-email-pratheesh@ti.com> <alpine.LFD.2.00.1102232057260.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102232057260.2701@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-02-2011 23:25, Thomas Gleixner wrote:

>> +	prussio_virt_addr =
>> +	    ioremap(regs_prussio->start,
>> +		    regs_prussio->end - regs_prussio->start + 1);

> Either make those variable names shorter or do:

>         len = regs_prussio->end - regs_prussio->start + 1;

    Or even:

	len = resource_size(regs_prussio);

>         prussio_virt_addr = ioremap(regs_prussio->start, len);

WBR, Sergei
