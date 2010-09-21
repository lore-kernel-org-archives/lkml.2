Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab0IUEv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:51:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58293 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0IUEvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=srpciCTm0imC7i+lfuSQJ+mXrLrA66ZAzqq2+lOictgzy1uX6/m/3SSxpMYj5wjdLJ
         sjHsrnft+Y2+z0QTWTuTkN/BXv+lJ5sUMJ73GHY7KVchW3DK/f4s0nXX3WbN6PPrVfZ3
         r4OEo5WJ8XA0GodUSQtmjsRGC/8CwNmJq384M=
Message-ID: <4C9839CE.7030804@gmail.com>
Date: Mon, 20 Sep 2010 21:51:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <20100920213234.ca0e3684.rdunlap@xenotime.net>
In-Reply-To: <20100920213234.ca0e3684.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 09:32 PM, Randy Dunlap wrote:
> On Mon, 20 Sep 2010 21:18:44 -0700 Justin P. Mattock wrote:
>
>> Below you will find a patch containing updates to broken web addresses in the kernel.
>> Some were easy to piece together, but some were knowhere to be found..Keep in mind this was
>> just a grep for "http", not sure how many other protocol's in there are working or not..
>> Thanks for the replies, if you see anything that I might have missed let me know...
>> (as for the signed-off's not sure if it's the best way, but figured if you replied
>> with a correct link, then why not!!).
>
> I think that you need to read Documentation/SubmittingPatches:
> section 13) When to use Acked-by: and Cc:
>
> to know when to use those keywords.  I expect that most of these are
> inappropriate.
>
>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> Signed-off-by: Maciej W. Rozycki<macro@linux-mips.org>
>> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
>> Signed-off-by: Finn Thain<fthain@telegraphics.com.au>
>> Signed-off-by: Randy Dunlap<rdunlap@xenotime.net>
>> Signed-off-by: Matt Turner<mattst88@gmail.com>
>> Signed-off-by: Dimitry Torokhov<dmitry.torokhov@gmail.com>
>> Signed-off-by: Ben Pfaff<blp@cs.stanford.edu>
>> Signed-off-by: Mike Frysinger<vapier.adi@gmail.com>
>> Acked-by: Hans J. Koch<hjk@linutronix.de>
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

I can resend with this correct...

so I need to have:
Signed-off-by: Random J Developer <random@developer.example.org>
[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>

Justin P. Mattock
