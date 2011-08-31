Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1HaTpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:45:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57571 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1HaTp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:45:28 -0400
Message-ID: <4E5E8F04.9030303@zytor.com>
Date: Wed, 31 Aug 2011 12:44:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108311839.52863.arnd@arndb.de> <CA+55aFwVJ71=cLsUqMaJ-eGP0doPGBhrse9r++hkbiNYNx5Zjg@mail.gmail.com> <1397886.AAh13B9r2H@wuerfel>
In-Reply-To: <1397886.AAh13B9r2H@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 12:18 PM, Arnd Bergmann wrote:
>>
>> You do realize that there are probably quite a lot of programs that
>> depend on signed time_t because they really do care about dates before
>> 1970?
> 
> Yes, it already occurred to me after I had written the above that we
> really want it to be signed, especially to allow a meaningful conversion
> at least one-way between 32 and 64 bit time_t values.
> 

The only reason I mentioned redefining 32-bit time_t as unsigned was for
*legacy ABIs*.

	-hpa


