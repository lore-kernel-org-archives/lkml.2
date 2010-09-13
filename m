Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0IMR2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:28:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52475 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0IMR2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:28:02 -0400
Message-ID: <4C8E5EDB.2070900@zytor.com>
Date: Mon, 13 Sep 2010 10:26:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, florian@mickler.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
References: <1284366708-30154-1-git-send-email-florian@mickler.org> <1284367195.2275.29.camel@laptop> <20100913163322.GA3819@n2100.arm.linux.org.uk>
In-Reply-To: <20100913163322.GA3819@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 09:33 AM, Russell King - ARM Linux wrote:
>>
>> Does it in fact still build with 3.4? I seem to recall some talk about
>> pushing the minimum version to 4.x for x86, although I can't remember
>> where..
> 
> I'm still building kernels with gcc 3.4.3 (for the ARMs which don't
> require a later compiler) or gcc 4.3.2+patches for those which do.
> 
> ARM gcc 3.4.3 is certainly noticably faster than gcc 4.3.2 even on
> x86 - and as long as ARM gcc 3.4.3 works, and there's not great pain
> in allowing it to build the arch-independent stuff, I see no reason
> to deny it across the entire kernel build.
> 
> I think we should have a minimum compiler version for the generic
> kernel, and individual minimum compiler versions for the architectures,
> so that arches can specify a higher minimum compiler version if they
> have specific problems there.

Yes, I don't think anyone has proposed bumping past 3.4 for the generic
kernel at this time.

	-hpa
