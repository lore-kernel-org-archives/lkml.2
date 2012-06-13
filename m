Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2FMHaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:30:25 -0400
Received: from mail.pr.hu ([87.242.0.5]:37256 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2FMHaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:30:24 -0400
Message-ID: <4FD8417B.8020702@pr.hu>
Date: Wed, 13 Jun 2012 09:30:03 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
References: <4FD4F45D.5050103@pr.hu> <20120611084318.GA1685@liondog.tnic> <20120611094905.GA10349@liondog.tnic> <20120611110557.GA4599@sig21.net>
In-Reply-To: <20120611110557.GA4599@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.8 (--)
X-Scan-Signature: 7a6493e989a703e6709937009417634f
X-Spam-Tracer: backend.mail.pr.hu -2.8 20120613072936Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-06-11 13:05 keltezéssel, Johannes Stezenbach írta:
> On Mon, Jun 11, 2012 at 11:49:05AM +0200, Borislav Petkov wrote:
>> On Mon, Jun 11, 2012 at 10:43:18AM +0200, Borislav Petkov wrote:
>>> On Sun, Jun 10, 2012 at 09:24:13PM +0200, Boszormenyi Zoltan wrote:
>>>> I have an AMD FX-8120 boxed CPU in an ASUS M5A99X-EVO mainboard
>>>> with 32GB DDR3/1600 memory, running Fedora 17, upgraded from 16.
>>>> memtest86+ show no problems.
>> Ohe other thing: if there's an option in the BIOS to disable the IOMMU,
>> can you do that and try reproducing the issue with IOMMU disabled?
> Maybe not related, but I had bad memory in my Intel Core-i5
> based system some months ago which resulted in rare crashes,
> usually manifested itself as g++ ICEs when compiling a
> mid-sized  C++ project -- compiling a kernel with make -p4 showed
> no problem.  Also memtest86+ didn't show the issue,
> so I tried memtest86-4.0a which claims to find more errors
> due to SMP support.  An overnight run left me with a screen
> full of garbage and a crashed memtest86-4.0.  I replaced
> the RAM anyway and the box was stable since then.
>
> memtest86-4.0a is at
> http://memtest86.com/
>
> The page claims:
>    With a single CPU it is not possible to drive multi-channel memory
>    controllers at full speed making it impossible to detect some types of errors
>
> Maybe someone knowledgable could comment if this is true.

This one locked up on my machine but memtest86+ 4.20 detected
12 different addresses with faulty bits in the lower 16GB. Applying
for warranty.

With only two modules, "make -j8" succeeded a lot of times.

Thanks for everyone who tried to help.

Best regards,
Zoltán Böszörményi

