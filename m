Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1AKB1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:27:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54755 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1AKB1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:27:14 -0500
Message-ID: <4D2BB1A4.5090404@kernel.org>
Date: Mon, 10 Jan 2011 17:25:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/4] x86, usb, pci: Disable usb legacy support early
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org> <4D2BA8FE.9090204@kernel.org> <20110111010739.GC32585@kroah.com>
In-Reply-To: <20110111010739.GC32585@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 05:07 PM, Greg KH wrote:
> On Mon, Jan 10, 2011 at 04:49:02PM -0800, Yinghai Lu wrote:
>>
>> Move quirks for usb handoff early for x86.
>>
>> So we can get stable result when trying to calibrate apic timer with pm-timer.
> 
> I still fail to understand _why_ you are making these changes.
> 
> Exactly what problem do you currently have, on what hardware, that this
> patch set solves?
1. remove the warning 
2. apic timer clockevent will be more accurate instead of use PM to calibrate it.

on Intel newer system with 128 logical cpus or more.

guess SMI handler for USB legacy support may need more time coordinate between those cpus.

Thanks

Yinghai 
