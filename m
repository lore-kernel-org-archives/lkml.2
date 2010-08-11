Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0HKTKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:10:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58862 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0HKTKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:10:21 -0400
Message-ID: <4C62F574.7000300@zytor.com>
Date: Wed, 11 Aug 2010 12:09:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>	 <87k4o08fv9.fsf@basil.nowhere.org> <1281336031.976.11.camel@leonhard>	 <20100809064441.GC29524@basil.fritz.box> <1281337485.976.24.camel@leonhard>	 <20100809072226.GD29524@basil.fritz.box> <4C604F54.2080506@zytor.com>	 <20100810070555.GA16638@elte.hu>  <1281437191.1670.33.camel@leonhard> <1281505466.1677.13.camel@leonhard>
In-Reply-To: <1281505466.1677.13.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 10:44 PM, Namhyung Kim wrote:
> 2010-08-10 (화), 19:46 +0900, Namhyung Kim:
> 
>> No problem. :-) But before that, let me clarify this: It seems
>> -fno-strict-overflow is all about the signed arithmetic and
>> __pa_symbol() does unsigned one. Is it really matters here?
>>
> 
> Oops, my bad, I found the description of -fstrict-overflow in gcc manual
> that it also affects the semantics of pointer and unsigned integer
> arithmetic. Sorry for the noise.
> 

Not unsigned integers, those are defined by the C standard to wrap.

	-hpa
