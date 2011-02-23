Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1BWFcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:32:35 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:33069 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab1BWFce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:32:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rDVfKRMNSU+B63dkEYUzfL/a4MzhD43JcvypL/hqSKrhVVSu/PQdKQRiXQY3IygAiH
         4X0+a0NoRFhER7bB0xG0LHz7vntALXfS8TvP/crkPvC289un+ASukcBYbMJvoBe3D9sm
         bVc95GfmaqC7uJAokZqso8kb3zKfqXgEVt5uw=
MIME-Version: 1.0
In-Reply-To: <m3mxm2mt5n.fsf@fleche.redhat.com>
References: <AANLkTikhfhYjvmvXtjW-Mszpq8d_3Syo=H4zqWe+1hEg__12255.0142732964$1296923928$gmane$org@mail.gmail.com>
 <m3hbcfzu9u.fsf@fleche.redhat.com> <AANLkTinMx8mJYiDps3TuuaA1B4NLHi-PuCKm2=sTqyR0@mail.gmail.com>
 <m3y65qv7m8.fsf@fleche.redhat.com> <AANLkTi=UrBZUttP9Q=2DrNXs8MAw4FXWhv6f_Pz8ad8o@mail.gmail.com>
 <m3mxm2mt5n.fsf@fleche.redhat.com>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 23 Feb 2011 13:32:13 +0800
Message-ID: <AANLkTinBDpw6wPtOC5f2GhibHcYiGAg2=v2KF1+PTm57@mail.gmail.com>
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

Hi Tom,

I have updated the VTA introduce to https://code.google.com/p/kgtp/wiki/HOWTO
Thanks for your help.

Best,
Hui

On Sat, Feb 12, 2011 at 00:29, Tom Tromey <tromey@redhat.com> wrote:
>>>>>> ">" == Hui Zhu <teawater@gmail.com> writes:
>
>>> Handle the var is enough for KGTP.  Could you send me a introduce
>>> link for VTA?  I will post the the VTA to the HOWTO of the kgtp.
>
> Here's the original plan:
> http://gcc.gnu.org/wiki/Var_Tracking_Assignments
>
> Alexandre also wrote a paper about it for the GCC Summit.  You can
> probably dig that up without much effort.  There's also a follow-up
> effort, the paper there is called "Consistent Views at Recommended
> Breakpoints".  This one hasn't been implemented yet, though.
>
> Tom
>
