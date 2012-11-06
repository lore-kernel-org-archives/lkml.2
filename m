Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab2KFLEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:04:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44978 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2KFLD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:03:59 -0500
MIME-Version: 1.0
In-Reply-To: <s5hy5if80kq.wl%tiwai@suse.de>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
	<CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
	<s5h8vafi56z.wl%tiwai@suse.de>
	<CACVXFVPDZnXshvartbTt6gaGzcb+03sVq3Qm3apQQ8AVcQWerg@mail.gmail.com>
	<s5h4nl3i3u6.wl%tiwai@suse.de>
	<CACVXFVPJ0TWf=ffFhw+UGoGgsRnrD7o+Ws5rdDxS52jSf4SZ4A@mail.gmail.com>
	<s5h1ug7i1q5.wl%tiwai@suse.de>
	<CACVXFVOOEf=Ype=2OGjjjgXZWo=5xd8Hhu2CSTaKTtGAybaA=w@mail.gmail.com>
	<s5h4nl39gt9.wl%tiwai@suse.de>
	<CACVXFVOzRxp9owV5O9NFLuL5md04Bmu35oCuNvnVsZAzmHxH=A@mail.gmail.com>
	<s5hy5if80kq.wl%tiwai@suse.de>
Date: Tue, 6 Nov 2012 19:03:58 +0800
Message-ID: <CACVXFVOEagv_BgZCTzEgRSpaHEiM6ptNuXAePUaXDb8GfRogSw@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
From: Ming Lei <tom.leiming@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 6:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 6 Nov 2012 18:40:57 +0800,
>> It is true if all firmwares are signed on safe boot. If firmware is allowed
>> to be loaded from network or other non-fs place in secure distribution,
>> your patch will break this loading.
>
> Do we already have such a secure mechanism?  How is the security
> assured?

I don't know, and my comments are just on your patch and the condition.
I understand secure guys should know if the condition may be true or false, :-)

>> The clue can be found from debug message.
>
> Debug messages are turned off on normal machines, unfortunately.

Kernel guys will put one eye on bug report, also enabling udev log
can help the problem too.


Thanks,
-- 
Ming Lei
