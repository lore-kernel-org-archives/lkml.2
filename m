Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1AJTzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:55:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20144 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab1AJTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:55:10 -0500
Message-ID: <4D2B63C1.6050606@kernel.org>
Date: Mon, 10 Jan 2011 11:53:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/3] x86: early_quirk check all dev/func in domain 0
References: <4D2A1152.1040903@kernel.org> <4D2A13AA.5070501@kernel.org> <20110110160117.GD5275@kroah.com>
In-Reply-To: <20110110160117.GD5275@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 08:01 AM, Greg KH wrote:
> On Sun, Jan 09, 2011 at 11:59:38AM -0800, Yinghai Lu wrote:
>>
>> go with all buses instead of bus0.
> 
> Why?  Why limit yourself here?

early stage pci access is via cf8, and we can not use domain there. aka domain is 0.

> 
> What's to say I will not have a USB controller on the second domain?  If
> you are going to change this, might as well be "correct", right?

later pci-quirks is still there. for the domain 0's will do it early. later pci-quirks will check it again.

> 
> Or, if it really doesn't matter, stick with what we have today.

we can avoid to adjust apic timer delta with pm-timer.

Thanks

Yinghai
