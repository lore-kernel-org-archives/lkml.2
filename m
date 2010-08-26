Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0HZVRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:17:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59911 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab0HZVRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:17:07 -0400
Message-ID: <4C76D9A0.2010907@zytor.com>
Date: Thu, 26 Aug 2010 14:16:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
CC: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
References: <20100825094925.GA3632@pema> <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain> <20100826210815.GA18131@pema>
In-Reply-To: <20100826210815.GA18131@pema>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 02:08 PM, Shérab wrote:
> 
>> Does Linux run in ACPI mode?
> 
> I don't think so.
> 

No, doesn't look like it.

>> Please send along the dmesg from a Linux kernel built with:
>>
>> CONFIG_ACPI=y
>> CONFIG_ACPI_DEBUG=y
> 
> It's attached.
> 

What about APM?

	-hpa
