Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab0HESXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:23:08 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34909 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760518Ab0HESXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=pQ6PB5MOUymbL77+vYfxVApc77MbVWA7qJvYTe2g8fWOiB6aQwM0qje0CCA9xXzMHg
         RihbeRbGcnQpqfuOyHXscmJAmR8YuDO/VRuufYlCD5BA+gbMwbc9YsX5Mk6Z0Sd11l+Z
         5cTmoYhH7KtmB0vJwphKU5f4i2TM3qffksFNA=
MIME-Version: 1.0
In-Reply-To: <20100804145258.GC17666@tuxdriver.com>
References: <4C5950B7.4000802@archlinux.org> <20100804134908.GB17666@tuxdriver.com> 
	<4C59790C.4010809@archlinux.org> <20100804145258.GC17666@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 5 Aug 2010 11:22:44 -0700
X-Google-Sender-Auth: jck9CdOthkr63kNj0o1mjTv5_uE
Message-ID: <AANLkTimPznW41N0aqkqjAKZdt73ugY2KBoRXFNPxuTOT@mail.gmail.com>
Subject: Re: WARNING at net/wireless/reg.c when wireless network is 
	disconnected
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?Q?Thomas_B=C3=A4chler?= <thomas@archlinux.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 7:52 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Aug 04, 2010 at 04:28:28PM +0200, Thomas Bächler wrote:
>> Am 04.08.2010 15:49, schrieb John W. Linville:
>> > On Wed, Aug 04, 2010 at 01:36:23PM +0200, Thomas Bächler wrote:
>> >> Hello,
>> >>
>> >> this warning has been around ever since I switched to 2.6.34, has
>> >> accompanied me through the 2.6.35-rc* phase and is still there with
>> >> 2.6.35. I didn't bother to report it so far, as there seems to be no harm.
>> >>
>> >> Whenever I disconnect/get disconnected from the wireless, I receive the
>> >> below warning:
>> >>
>> >> ------------[ cut here ]------------
>> >> WARNING: at net/wireless/reg.c:272
>> >> regulatory_hint_disconnect+0x1b3/0x230 [cfg80211]()
>> >> Hardware name: TECRA A11
>> >> Unexpected user alpha2: de
>> >
>> > Perhaps you need to set the regdomain as "DE" rather than "de"?
>> >
>> > John
>>
>> You are actually right. I did set it to "DE" with iw, but wpa_supplicant
>> had a setting country="de". I just fixed that and will soon see if the
>> problem disappears.
>>
>> Still, the warning shouldn't look like a bad kernel bug, but rather an
>> advisory to the user to set something sane. What confuses me even more
>> is that this has been set to DE afterwards:
>
> Perhaps we should just upcase the alpha2 value?  I'm not sure why we don't.

It just needs to be implemented.

  Luis
