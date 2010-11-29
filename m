Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0K2VX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:23:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59718 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0K2VX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:23:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ogACD4FR6uSmny3TG1kM6ODFQS7ES11xCNqKBGi9y2Z+mzh5vhDt9TznTUH0dNZgqz
         OIGYTValKHBsZzux6utqnQ4aJl3VUdosdbIubWVPO7oopbf8GwMqsUnuAHrYsD2av4Ok
         Fx/4o9RAzg+vfg/Q/U73z4XIRghKrREPOcsPM=
MIME-Version: 1.0
In-Reply-To: <12794.1291053037@localhost>
References: <1290941875.13526.15.camel@cai.gentoo>
	<73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	<1290951770.13526.18.camel@cai.gentoo>
	<AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	<20101129020610.7ea7c79e.lisa@ltmnet.com>
	<1290961207.13526.31.camel@cai.gentoo>
	<20101128194624.GP2767@thunk.org>
	<4CF3081B.9090307@gmail.com>
	<1290996846.877.23.camel@cai.gentoo>
	<12794.1291053037@localhost>
Date: Mon, 29 Nov 2010 16:23:24 -0500
Message-ID: <AANLkTim5RHNQnFG-fUJ=zXk1Zz4uhf3+dLGU4MwXq5Sr@mail.gmail.com>
Subject: Re: VT console need rewrite
From: Jerome Glisse <j.glisse@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: microcai@fedoraproject.org, Alexey Gladkov <gladkov.alexey@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:50 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 29 Nov 2010 10:14:06 +0800, Microcai said:
>
>> The thing is, you really should agree that, implementing UNICODE font in
>> kernel isn't a bad idea.
>
> Let us know when you have implemented support for bidirectional
> scripts that require compositing or half-spacing characters.  Without
> blowing out the 8K kernel stack.
>
> Doing it *right* is important:
>
> http://gizmodo.com/382026/a-cellphones-missing-dot-kills-two-people-puts-three-more-in-jail
>
> Two dead, three in jail.  All because of broken font support.  That's a good
> reason to not even try unless you can do it *right*.
>
>

Side point, KMS people would like to see the direct memory access to
fb buffer vanish, right now we are wasting vram to keep a front buffer
around for fb. So somethings like always using some callback to access
(write/read) to fb buffer.

Cheers,
Jerome Glisse
