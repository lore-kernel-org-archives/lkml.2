Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab2AFCE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:04:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50161 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278Ab2AFCE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:04:27 -0500
Message-ID: <4F06566B.8080708@zytor.com>
Date: Thu, 05 Jan 2012 18:03:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com> <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com> <20120106014748.GS11715@one.firstfloor.org>
In-Reply-To: <20120106014748.GS11715@one.firstfloor.org>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 05:47 PM, Andi Kleen wrote:
>>
>> Is that still true, and do we even use string instructions still on
>> those old CPUs?  Jan's fixes don't introduce any additional delays in
>> the non-string-instruction paths.
> 
> Yes various of the CPUs with bugs used string instructions.
> 

Which CPUs are you talking about here?

> 
> Both string and non string instructions are used on modern CPUs,
> so making any of that slower is not a good idea.
> 

Obviously not, but I'm perfectly fine turning REP_GOOD off on old broken
CPUs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

