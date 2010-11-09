Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0KIU2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:28:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45563 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0KIU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:28:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Zfrprskaf9XHkzt47VwXyyOfUH1A569af299DxHMCNqjCvHtK7A1v3rbBIWQu9Kjgn
         fBKvTPInXvswteb41bOWwetHD19hvZtHMuBxNbCwDL7T8/lJA3JBC93jN+oLA0G7le7x
         3GYAhKdakt4QgqQEKlTsCYC1bdPC9frvtmTq8=
MIME-Version: 1.0
In-Reply-To: <20101109195622.GR5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109181525.GH5876@outflux.net>
	<AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com>
	<20101109191908.GO5876@outflux.net>
	<AANLkTi=zU=RxqMX_h=BM4WchgCbwTi9tWa0SkhxmDwcg@mail.gmail.com>
	<20101109195622.GR5876@outflux.net>
Date: Tue, 9 Nov 2010 22:28:16 +0200
X-Google-Sender-Auth: BrcD_U94uIJRB1WEX2Pw-a8530k
Message-ID: <AANLkTik3C01Pvv_RvgKXctjKjw=XS4AeEN94ADZtw+sW@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Tue, Nov 09, 2010 at 09:46:39PM +0200, Pekka Enberg wrote:
>> I actually don't see 0/4 or 2/4 on LKML yet. It would be better to
>> have the rationale in the patch that changes the code for future
>> reference. The summary email will be lost in the noise much more
>> easily.

On Tue, Nov 9, 2010 at 9:56 PM, Kees Cook <kees.cook@canonical.com> wrote:
> Looks like delivery delays somewhere. I see it in the archive:
> http://lkml.org/lkml/2010/11/9/380

So why can't we do patch 2/4 XD_DISABLE clearing in
early_init_intel()? Why do we want to call verify_cpu() from
arch/x86/kernel/head_32.S and not from
arch/x86/boot/compressed/head_32.S like we do on 64-bit?

                        Pekka
