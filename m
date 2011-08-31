Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1HaUD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:03:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57700 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab1HaUD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:03:27 -0400
Message-ID: <4E5E9347.4010503@zytor.com>
Date: Wed, 31 Aug 2011 13:02:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108311839.52863.arnd@arndb.de> <CA+55aFwVJ71=cLsUqMaJ-eGP0doPGBhrse9r++hkbiNYNx5Zjg@mail.gmail.com> <1397886.AAh13B9r2H@wuerfel> <4E5E8F04.9030303@zytor.com> <20110831205439.1a0c94da@lxorguk.ukuu.org.uk>
In-Reply-To: <20110831205439.1a0c94da@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 12:54 PM, Alan Cox wrote:
>>
>> The only reason I mentioned redefining 32-bit time_t as unsigned was for
>> *legacy ABIs*.
> 
> But if you redefine it then it's not a legacy ABI any more - its a new
> ABI.

Only sort-of-kind of.  It's like hacking around the Y2K problem by date
windowing; it technically it is an ABI change but when it is going to
break anyway...

	-hpa
