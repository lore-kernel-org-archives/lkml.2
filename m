Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0H3Nc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:32:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58075 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab0H3Ncz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=O++hHsPiyhQFF3R829HOPUbDl2glsy1c5tXyHhs82Mw2d5LThQ4q1RcJ2BsZ0mF3Vo
         zAax74EsbWDRuhiWwbM7m3wBoKnbT0VD7cn5TNsrNfNez16RDKrRawmJ9bOATwRigYQx
         EiQyRugM1mICb08LK7SGPfN2/t1NGe1DtRRJc=
MIME-Version: 1.0
In-Reply-To: <1283173173.12995.75.camel@brekeke>
References: <1283028125-6027-1-git-send-email-vapier@gentoo.org>
 <1283173086.12995.74.camel@brekeke> <1283173173.12995.75.camel@brekeke>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 30 Aug 2010 09:32:15 -0400
X-Google-Sender-Auth: a8LTq5j8u38wkHimE3NHXLnwN2Y
Message-ID: <AANLkTikE93Uqnf7_8p72rEhcRydmx0LdBVCM_z3tNr-z@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] mtd: Blackfin NFC: fix invalid free
 in remove()
To: dedekind1@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 08:59, Artem Bityutskiy wrote:
> On Mon, 2010-08-30 at 15:58 +0300, Artem Bityutskiy wrote:
>> On Sat, 2010-08-28 at 16:42 -0400, Mike Frysinger wrote:
>> > Since info->mtd isn't dynamically allocated, we shouldn't attempt to
>> > kfree() it.  Otherwise we get random fun corruption when unloading
>> > the driver built as a module.
>> >
>> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> > ---
>> > note: this should be merged for 2.6.36 and probably sent to stable trees
>>
>> You send the same patch 2 times once with this note and the other time
>> without this note. Which one should be ignored?
>
> I guess it is 2.6.36 material. Also, if you want this in -stable, add
> corresponding CC please.

once it gets merged, then i can notify the stable guys
-mike
