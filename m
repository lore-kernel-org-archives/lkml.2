Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1BHNYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:24:15 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46578 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1BHNYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cAgCsSarg1+LWNkED/1x4LbMxPNUyoLzg1MegAMHMqMcNI6rK9Sarm9+A8hHemQvvv
         o67FkifhY/IshZZuqP00HR4yB7qZwdY00t/qDGDYuPxSpX7kUyfSo+WojY8NCSCv2Hha
         5o/26NGQTuwEsn5I0gwQgciHmlKiSk4IRTClo=
MIME-Version: 1.0
In-Reply-To: <m3hbcfzu9u.fsf@fleche.redhat.com>
References: <AANLkTikhfhYjvmvXtjW-Mszpq8d_3Syo=H4zqWe+1hEg__12255.0142732964$1296923928$gmane$org@mail.gmail.com>
 <m3hbcfzu9u.fsf@fleche.redhat.com>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 8 Feb 2011 21:23:52 +0800
Message-ID: <AANLkTinMx8mJYiDps3TuuaA1B4NLHi-PuCKm2=sTqyR0@mail.gmail.com>
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

On Tue, Feb 8, 2011 at 00:25, Tom Tromey <tromey@redhat.com> wrote:
>>>>>> ">" == Hui Zhu <teawater@gmail.com> writes:
>
>>> We have trouble for this printf is GDB is still not accept the patch
>>> that make tracepoint support printf, So if you want use it, you need
>>> patch the patch in
>>> http://sourceware.org/ml/gdb-patches/2011-02/msg00063.html and build
>>> your GDB with yourself.
>
> Thanks, I think this example was helpful.
>
>>> Sometimes, GDB will output some value like:
>>> inode has been optimized out of existence.
>>> res has been optimized out of existence.
>>> That is because value of inode and res is optimized. Linux Kernel is
>>> built with -O2 so you will get this trouble sometimes. If you do not
>>> care about the speed when you debug the Kernel, you can use the patch
>>> for Linux Kernel in
>
> I am curious to know what version of GCC you are using.  IME, the VTA
> patches really helped with this problem a lot -- though not completely.
> If you are not using a VTA-enabled GCC, you should.  And if you are, I
> think bug reports about values that are still optimized out would be
> useful.

My gcc is 4.4.5.  Does it have VTA?
Use the patch is easier than update gcc sometimes, right?  :)

BTW does VTA can handle the issue that after -O2 a lot of code
execution order is worong?
It affect me when I debug the Linux Kernel in qemu.

Thanks,
Hui
