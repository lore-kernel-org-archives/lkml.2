Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab1BIN0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 08:26:12 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57149 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1BIN0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 08:26:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IaAag1QDGUzF7xoLQCgcuTtGs6nMo0iu8eVado+TgqESnvZvgwRclfSie2F8hagBwX
         uQMiY3EavPFPERGt8xEZv92NsMx58nt/wQF3h7hbLKgFHZUhn5xJMpGf6vTCBqgtR8AN
         XHVs/zaZyma60C9K6Q7TFWC0mhFLkYRf+k2y4=
MIME-Version: 1.0
In-Reply-To: <m3y65qv7m8.fsf@fleche.redhat.com>
References: <AANLkTikhfhYjvmvXtjW-Mszpq8d_3Syo=H4zqWe+1hEg__12255.0142732964$1296923928$gmane$org@mail.gmail.com>
 <m3hbcfzu9u.fsf@fleche.redhat.com> <AANLkTinMx8mJYiDps3TuuaA1B4NLHi-PuCKm2=sTqyR0@mail.gmail.com>
 <m3y65qv7m8.fsf@fleche.redhat.com>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 9 Feb 2011 21:25:50 +0800
Message-ID: <AANLkTi=UrBZUttP9Q=2DrNXs8MAw4FXWhv6f_Pz8ad8o@mail.gmail.com>
Subject: Re: [PATCH] Linux Kernel GDB tracepoint module 2011-02-05
To: Tom Tromey <tromey@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 00:00, Tom Tromey <tromey@redhat.com> wrote:
>>>>>> ">" == Hui Zhu <teawater@gmail.com> writes:
>
>>> My gcc is 4.4.5.  Does it have VTA?
>
> Nope.  VTA went in for 4.5.
>
>>> Use the patch is easier than update gcc sometimes, right?  :)
>
> Yeah.
>
>>> BTW does VTA can handle the issue that after -O2 a lot of code
>>> execution order is worong?
>>> It affect me when I debug the Linux Kernel in qemu.
>
> My understanding is that VTA is solely about better tracking of values
> through optimization passes.  It doesn't affect code reordering, by
> design.
>
> Tom
>

Thanks Tom.

Handle the var is enough for KGTP.  Could you send me a introduce link for VTA?
I will post the the VTA to the HOWTO of the kgtp.

Best,
Hui
