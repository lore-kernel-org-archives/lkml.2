Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1ISSAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:00:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54226 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab1ISR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:59:59 -0400
Message-ID: <4E778318.5010905@gmail.com>
Date: Mon, 19 Sep 2011 18:59:52 +0100
From: Dave Kilroy <kilroyd@googlemail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: henk.de.groot@hetnet.nl
CC: linux-kernel@vger.kernel.org, greg@kroah.com, pe1dnn@amsat.org
Subject: Re: [PATCH 00/13] wlags49_h2: Various cleanups
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com> <4E73BB61.7020407@hetnet.nl>
In-Reply-To: <4E73BB61.7020407@hetnet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/2011 22:10, Henk de Groot wrote:
> I applied your patches against the current 3.0 linux kernel driver code
> and compiled it on my Ubuntu 11.04 system (2.6.38-11). I can confirm the
> modified driver is still working okay using a Thomson Speedtouch 110
> Wifi card with WEP.

Thanks for confirming this.

> WPA was - and I guess still is - non functional.

Do you have any idea why this is happening? If the WPA bits are verbatim 
from the 7.22 Agere driver this should be functional. I can only think 
that some WEXT changes have caused this breakage.

> The only known problem (besides WPA) is removal and reinserting the
> PCMCIA card. It is not recognized anymore on that slot. The card works
> on a second PCMCIA slot. This is old behaviour and not due to your
> changes (however this worked with older kernels).

I have less idea about what is happening here, but it sounds like 
there's insufficient initialisation/cleanup.

If you post (or point me at) a WPA supplicant log (with -ddd) I'll take 
a look at the problem. I may also submit a patch to remove the unused 
code in wl_wext.c - it seems trivial to fix up.


Dave.
