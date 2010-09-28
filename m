Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0I1NlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:41:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60563 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab0I1NlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=txK7VntpM3Eu/SKu/iDBllwsI6nvbYe+JkfLFoXpeCv8a7iq45hDSOv9siTU565g1y
         toClR3zEUwnhL23dosEkieoqatMouJlTWaG3HT2ytAhVWdcbOhwnVtKcDRmpwDV0krV2
         +JeHelKH7E6op0xekFwnaE6oJjk74ssfzsk1U=
Message-ID: <4CA1F082.2010900@gmail.com>
Date: Tue, 28 Sep 2010 06:41:22 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org,
        linux-ide@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [RFC v5]update broken web addresses in the kernel.
References: <1285647599-14719-1-git-send-email-justinmattock@gmail.com> <alpine.OSX.2.00.1009281613260.276@localhost> <4CA193B6.8020503@gmail.com> <alpine.OSX.2.00.1009281713410.276@localhost>
In-Reply-To: <alpine.OSX.2.00.1009281713410.276@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 12:35 AM, Finn Thain wrote:
>
> On Tue, 28 Sep 2010, Justin P. Mattock wrote:
>
>> o.k... I'll make the changes to the arch patch, and combine the two, and
>> send it to jiri..
>
> Why?
>
> My advice is don't do it unless you want to waste reviewers' time.
>
>> as for the names and signed offs is what is below fine or do I need to
>> change some of them?
>
> If you combine patch 1 and patch 2 and submit that as patch 3, you will
> likely have to CC patch 3 to everyone to whom you sent patch 1 plus
> everyone to whom you sent patch 2. You must also change any "acked-by" to
> "Cc", since patch 3 is new.
>
> Keep the same CC list since Jiri is already on it ("trivial@kernel.org").
>
> Finn
>

alright.. so it will be two patches then..(not the best at the CC etc.. 
thing) cool... and thanks again for reviewing this for me..(back 
breaking work, but somebodies _gots_ to do it..)

Justin P. Mattock
