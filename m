Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0H3PPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:15:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0H3PPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Cyx6Vep/QSN1AHSwkvtGDYY1alQZ8blEnlOiUgKWQMwssfzvFmstZ6NAnZpDQtaVlQ
         RKPEpUYw+IQILrBs/rGff6T1IVWHMhIOzRDVakTB2iHqMRUBCkTJu3HAyUnAl5hgodav
         4PKT9hsh8Wz/3SxJ34LXcj+22SzUZBsQ2PWFw=
MIME-Version: 1.0
In-Reply-To: <1283181047.2005.1.camel@brekeke>
References: <1283028125-6027-1-git-send-email-vapier@gentoo.org>
 <1283173086.12995.74.camel@brekeke> <1283173173.12995.75.camel@brekeke>
 <AANLkTikE93Uqnf7_8p72rEhcRydmx0LdBVCM_z3tNr-z@mail.gmail.com> <1283181047.2005.1.camel@brekeke>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 30 Aug 2010 11:14:41 -0400
X-Google-Sender-Auth: 8KpG0ojZkZFETUGJpn0ae0VihuQ
Message-ID: <AANLkTinsov-zKRVLePv-9DwFYMK9Pmr+CWfqFZSYpE8g@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] mtd: Blackfin NFC: fix invalid free
 in remove()
To: dedekind1@gmail.com
Cc: uclinux-dist-devel@blackfin.uclinux.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 11:10, Artem Bityutskiy wrote:
> On Mon, 2010-08-30 at 09:32 -0400, Mike Frysinger wrote:
>> On Mon, Aug 30, 2010 at 08:59, Artem Bityutskiy wrote:
>> > On Mon, 2010-08-30 at 15:58 +0300, Artem Bityutskiy wrote:
>> >> On Sat, 2010-08-28 at 16:42 -0400, Mike Frysinger wrote:
>> >> > Since info->mtd isn't dynamically allocated, we shouldn't attempt to
>> >> > kfree() it.  Otherwise we get random fun corruption when unloading
>> >> > the driver built as a module.
>> >> >
>> >> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> >> > ---
>> >> > note: this should be merged for 2.6.36 and probably sent to stable trees
>> >>
>> >> You send the same patch 2 times once with this note and the other time
>> >> without this note. Which one should be ignored?
>> >
>> > I guess it is 2.6.36 material. Also, if you want this in -stable, add
>> > corresponding CC please.
>>
>> once it gets merged, then i can notify the stable guys
>
> AFAIK, this is not the way they prefer to work. The right protocol is
> that you add 'Cc: stable@kernel.org' to the commit message, ane they
> pick the patch. I might be mistaken, but AFAIK this is the way.

np ... i'm not claiming to know more than you ;)
-mike
