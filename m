Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0KHTVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:21:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:49341 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0KHTVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:21:07 -0500
Message-ID: <4CD84D82.8020509@kernel.org>
Date: Mon, 08 Nov 2010 11:20:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix and clean up AMD Fam10 MMCONF enabling
References: <4CD2DDC6020000780002098C@vpn.id2.novell.com> <4CD454D1.2060503@kernel.org> <4CD7BC300200007800020E08@vpn.id2.novell.com>
In-Reply-To: <4CD7BC300200007800020E08@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2010 12:00 AM, Jan Beulich wrote:
>>>> On 05.11.10 at 20:02, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> looks like fam10h_pci_mmconf_base_status should NOT be removed.
>>
>> -1: mean we can not find right new base on BSP, so should not let AP to mess 
>> it again.
> 
> Note that is now achieved by clearing PCI_CHECK_ENABLE_AMD_MMCONF
> from pci_probe (imo a better way, as it inhibits code elsewhere which
> is protected by checks of this bit).

Then, please put that change in another patch.

Thanks

	Yinghai
