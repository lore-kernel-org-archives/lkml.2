Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab2FNEXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:23:46 -0400
Received: from mail.pr.hu ([87.242.0.5]:51796 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab2FNEXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:23:44 -0400
Message-ID: <4FD96742.9090700@pr.hu>
Date: Thu, 14 Jun 2012 06:23:30 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Johannes Stezenbach <js@sig21.net>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
References: <4FD4F45D.5050103@pr.hu> <20120611084318.GA1685@liondog.tnic> <20120611094905.GA10349@liondog.tnic> <20120611110557.GA4599@sig21.net> <4FD8417B.8020702@pr.hu> <20120613155733.GA17726@liondog.tnic> <4FD8DB3F.7050106@pr.hu> <20120613220651.GA12065@liondog.tnic>
In-Reply-To: <20120613220651.GA12065@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.1 (--)
X-Scan-Signature: 20745410fdb751dccea414568b749378
X-Spam-Tracer: backend.mail.pr.hu -2.1 20120614042256Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-06-14 00:06 keltezéssel, Borislav Petkov írta:
> On Wed, Jun 13, 2012 at 08:26:07PM +0200, Boszormenyi Zoltan wrote:
>> I did exactly that, the remaining two 8GB modules don't have faults
>> according to memtest86+ and the machine is stable with "make -j8" in
>> the kernel tree. Neither thunderbird nor firefox crashed for a day,
>> these are the usual victims when hitting the bad memory address.
> Cool.
>
> I guess you could try to limit it even further by taking a known-good
> 8GB module and pairing it with one of the "bad" ones to see whether one
> of the "bad" 8GB modules is faulty or both of them are.
>
> Or you could stop wasting time and go buy two new ones :-)

Yesterday I took the bad pair back to the shop with a screenshot
showing memtest86+ results and they accepted it for warranty.
I will get a new pair or RAMs for no extra fee.

