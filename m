Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2FMS0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:26:39 -0400
Received: from [87.242.0.5] ([87.242.0.5]:54341 "EHLO mail.pr.hu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2FMS0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:26:38 -0400
Message-ID: <4FD8DB3F.7050106@pr.hu>
Date: Wed, 13 Jun 2012 20:26:07 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Johannes Stezenbach <js@sig21.net>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
References: <4FD4F45D.5050103@pr.hu> <20120611084318.GA1685@liondog.tnic> <20120611094905.GA10349@liondog.tnic> <20120611110557.GA4599@sig21.net> <4FD8417B.8020702@pr.hu> <20120613155733.GA17726@liondog.tnic>
In-Reply-To: <20120613155733.GA17726@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Host-Lookup-Failed: Reverse DNS lookup failed for 87.242.63.98 (failed)
X-Spam-Score: -2.8 (--)
X-Scan-Signature: 9ff1c38e9b5eed4669b14ff547415cc5
X-Spam-Tracer: backend.mail.pr.hu -2.8 20120613182549Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-06-13 17:57 keltezéssel, Borislav Petkov írta:
> On Wed, Jun 13, 2012 at 09:30:03AM +0200, Boszormenyi Zoltan wrote:
>> This one locked up on my machine but memtest86+ 4.20 detected 12
>> different addresses with faulty bits in the lower 16GB. Applying for
>> warranty.
> If you have multiple DIMMs, you can also take out the DIMM which
> contains the 16GB and rerun memtest to confirm it really is the culprit.
>

I did exactly that, the remaining two 8GB modules don't have faults
according to memtest86+ and the machine is stable with "make -j8"
in the kernel tree. Neither thunderbird nor firefox crashed for a day,
these are the usual victims when hitting the bad memory address.

