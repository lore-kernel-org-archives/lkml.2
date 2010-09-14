Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0INIrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:47:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57183 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0INIro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aosyuf2umr90vbnOP2HSP1e8gz4wjyqB8jOfNJ8/oZw7GTimSfJs60GsKxedzk3muG
         d1dIJWSJ3rrpxhsELzi059wcGVdSzE1aRcrx0E25pVWDPlWPpOi43kwcRLlOmUJ1XqbO
         UvN9q1RWDgU9PewBLmT7XTKbn+FNr8d2+nTOU=
MIME-Version: 1.0
In-Reply-To: <4C8ECDFE.6010906@snapgear.com>
References: <20100914105129.02eb5b13.sfr@canb.auug.org.au>
	<4C8ECDFE.6010906@snapgear.com>
Date: Tue, 14 Sep 2010 10:47:42 +0200
X-Google-Sender-Auth: 2APvERt9MlAqDFj-7tMWkYR9UXA
Message-ID: <AANLkTim+7Q79hVv+r1PO2LeiiSCxb12CaqO3YuR8taL9@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 03:21, Greg Ungerer <gerg@snapgear.com> wrote:
> Stephen Rothwell wrote:
>>
>> Today's linux-next merge of the m68knommu tree got a conflict in
>> arch/m68k/sun3/sun3ints.c between commit
>> 72fe185cd9acbfc6e8a7afa884ae1152be706e52 ("m68k/m68knommu: Remove dead
>> SMP config option") from the m68k tree and commit
>> 5313b581e4efc214c6132d32f580db6668e5c5a8 ("arch/m68k{,nommu}: Removing
>> dead SMP config option") from the m68knommu tree.
>>
>> These appear to be the same patch with some formatting differences.  I
>> used the version from the m68k tree.
>
> Looks like Geert added the same patch to the m68k git tree.
> I'll drop it from the m68knommu git tree.

Sorry, I should have checked explicitly which patches were already in
the m68knommu git tree.
I did leave out one patch I knew (from email) Greg was going to take.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
