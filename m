Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1H3Qgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:36:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1H3Qgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:36:37 -0400
Message-ID: <4E5D1153.5030908@zytor.com>
Date: Tue, 30 Aug 2011 09:35:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108291704.08279.arnd@arndb.de> <4E5BDAF6.40000@zytor.com> <201108301409.27527.arnd@arndb.de>
In-Reply-To: <201108301409.27527.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 05:09 AM, Arnd Bergmann wrote:
> 
> I'm wondering about the time_t changes: given that we are still adding
> new 32 bit architectures, should we change the asm-generic API as well
> to use 64 bit time_t by default (with fallbacks for the existing ones)?
> 
> If you are adding support for these in x32 already, we could use the
> same code for regular 32 bit architectures.
> 

It seems absolutely boggling insane that we're introducing new
architectures with no legacy whatsoever and use 32-bit time_t on those.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

