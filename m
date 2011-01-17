Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab1AQChY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 21:37:24 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56901 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1AQChU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 21:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dLjlmY2uIpM4Lp+lnOcX5jLNDwvriw0TyVd0TZEvlyXTkfiEavNBnVnXf2TTBL8rTt
         Q29tPxuDuHcSddJAvMd/HnLGD9RwOPrujQVw8/c2NQ1w40VZijDhGxEh27jEqdDsm6hj
         icJOafRCOgeb4oez7+nCxKcP1DZpMaPiDv0iE=
MIME-Version: 1.0
In-Reply-To: <AANLkTikWZYOqxD_CyJ=zF2Lp2Mnt6Z2E1aPUspwMjrz_@mail.gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
	<AANLkTikWZYOqxD_CyJ=zF2Lp2Mnt6Z2E1aPUspwMjrz_@mail.gmail.com>
Date: Mon, 17 Jan 2011 11:37:19 +0900
Message-ID: <AANLkTinets0TKJmODLB4u9kH1v_KS3UWfxhvP-UQ=vmP@mail.gmail.com>
Subject: Re: [PATCH v4 00/24] Introduce little endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, Russell King <rmk@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/17 Linus Torvalds <torvalds@linux-foundation.org>:
> On Sun, Jan 16, 2011 at 5:08 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>
>> This problem is not touched.
>
> So why not? The thing is supposed to be a cleanup, but it generates
> uglier code and more lines added than removed. Why should I pull
> something like that?

Changing *_bit_le() to take "void *" instead of "unsigned long *"
makes this patch series acceptable?
Or do we also need to change *_bit_le() to handle unaligned address
correctly?  (i.e. not only long aligned address but also byte aligned
address)
