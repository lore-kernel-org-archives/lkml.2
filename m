Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0FNQ1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:27:45 -0400
Received: from mail-yw0-f204.google.com ([209.85.211.204]:36258 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab0FNQ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rDdvCQ61zcJSt0b+jo8lWDqTVWNfIGVHavuvVDvEpP3OlvTaEsiae2F25rHwfysQpT
         B12+0hF1cztRDYrNXZePtoNRcs0F9UxlWw/+fk/f02SXG9i1EL0Q43fOy+n4L9vfxep5
         Nm9kS8ibMoAPcmCIsW9FGmikKDX0+2lSjXIyM=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Noticeable slow-down in 2.6.35-rc3
Date: Mon, 14 Jun 2010 12:27:40 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
References: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com> <201006131813.04096.gene.heskett@gmail.com> <hv58sc$b1b$1@dough.gmane.org>
In-Reply-To: <hv58sc$b1b$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141227.40233.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 June 2010, walt wrote:
>On 06/13/2010 03:13 PM, Gene Heskett wrote:
>> Unfortunately, this patch will not apply to my src tree for 2.6.35-rc3,
>> even after I fixed the unwanted line wrap in the first active line.
>>
>> I get:
>>
>> [root@coyote linux-2.6.35-rc3]# patch -p1<../2.6.35-rc3-test.patch
>> patching file net/core/skbuff.c
>> Hunk #1 FAILED at 532.
>> 1 out of 1 hunk FAILED -- saving rejects to file net/core/skbuff.c.rej
>>
>> Did my grabbing it with swiftfox damage it even further?
>> ------------------------------------------------------------------
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 9f07e74..bcf2fa3 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -532,6 +532,7 @@ static void __copy_skb_header(struct sk_buff *new,
>> const struct sk_buff *old) new-&gt;ip_summed		= old-&gt;ip_summed;

It also seems that the whole string "&gt;ip_" has been traded for the 
leading c in the var names.  So that patch was totally trashed by a broken 
html converter by the time it actually got to my machine.

Where can I get a pristine copy?

I am also wondering if this has anything to do with my missing USB devices 
when booted to 2.6.35-rc3.  In my case the symptoms are as it it did not 
recurse far enough up the various branches of my usb tree from hell to find 
everything.

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
				FROM THE DESK OF
				Rapunzel

Dear Prince:

	Use ladder tonight -- you're splitting my ends.
