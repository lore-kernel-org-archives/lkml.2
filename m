Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0LJB6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:58:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33775 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0LJB6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:58:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZphfarEgy3OA7X7fBZfz81/0JbWuVoISUYrNGG3sohLNVpy7p+CpV+4DhQXtFvQc28
         r5dGfbxWKZSA9UazP749yIPQJ1n46AlyWoMR4XvnjJSkgkmZ/PSwdMqqdzgEhTMairDT
         DCzladyzl3IOpmvXBZvfn0/oNN10kjgLPAx+E=
MIME-Version: 1.0
In-Reply-To: <1291945065-sup-1838@think>
References: <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
	<20101207142145.GA27861@think>
	<AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
	<20101207182243.GB21112@redhat.com>
	<20101207193514.GA2921@thunk.org>
	<AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
	<20101209180111.GF2921@thunk.org>
	<AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
	<20101209201359.GG2921@thunk.org>
	<AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
	<20101209231616.GA12515@basil.fritz.box>
	<1291945065-sup-1838@think>
Date: Thu, 9 Dec 2010 17:58:40 -0800
X-Google-Sender-Auth: 1zBMuzO2wgm71LGDqjgIp8Em_Pw
Message-ID: <AANLkTimXznTKJAk7NAQPJC1op8iozsRCT5CHYm72hkkq@mail.gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
From: Mike Fedyk <mfedyk@mikefedyk.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jon Nelson <jnelson@jamponi.net>,
        "Ted Ts'o" <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>,
        Matt <jackdachef@gmail.com>, Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 5:38 PM, Chris Mason <chris.mason@oracle.com> wrote:
> Excerpts from Andi Kleen's message of 2010-12-09 18:16:16 -0500:
>> > 512MB.
>> >
>> > 'free' reports 75MB, 419MB free.
>> >
>> > I originally noticed the problem on really real hardware (thinkpad
>> > T61p), however.
>>
>> If you can easily reproduce it could you try a git bisect?
>
> Do we have a known good kernel?  I looked back through the thread and
> didn't see any reports where the postgres test on ext4 passed in this
> config.
>

2.6.34.something.  -- Any chance a newer kernel can be tested to be found good?
