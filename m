Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0IUFUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 01:20:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55789 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0IUFU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 01:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RdEXl/KsUKIlG0UlfhZXB82t6bClyiRXZmYbwIdrJU+LMrbADpE72ExCGDOMvzkSqT
         nE52KoMXiImPvfL74B4lacKT1p5kZWWZyLsO7Ki8X9fiNrlUn7CIYARTheUpuiSDQfvs
         kUXj8BZOPDymfYeLtnPwehKRcAqv7qPU1hXzk=
Message-ID: <4C9840A1.1030008@gmail.com>
Date: Mon, 20 Sep 2010 22:20:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com> <4C983C7D.1050000@gmail.com> <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com>
In-Reply-To: <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 10:11 PM, Matt Turner wrote:
> On Tue, Sep 21, 2010 at 1:02 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> didnt even think about that.. I really appreciate you pointing this out..
>>   I'll go through the whole thing and see if I can figure a good fix for the
>> archive.org stuff
>
> Just checked, and you can modify the links like so:
>
> - http://web.archive.org/web/*/http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
> + http://web.archive.org/web/%2A/http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
>
> So, change * to %2A (it's ASCII code in hex).
>
> I guess that's the least clunky fix.
>
> Matt
>


your a lifesaver I tell yeah... nice one..(just was crapping my pants 
trying to think how to fix this).

So I'll go through and change this to what you have. should I still keep 
alpha in?

then the signed-off's Ill put as Cc's until they give there signed-off.

Justin P. Mattock
