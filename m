Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab0LXJey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 04:34:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51009 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0LXJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 04:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rXzkFC5dku7Iv9+9LFxSsH4PPsSVlbOer4a+tACIB5vUY5Q1SeBErxDSO2XuIkBAVf
         UCwwkjFeLTMpmyYOlq8jub0wPa4Ib1YWFRpaY/mqje7m2+NhbJwTS86Y+6iCibUKEg7o
         RxXtJwx+4g93R6C9cceJS1jr+HJ+wSX6Gn/uE=
MIME-Version: 1.0
In-Reply-To: <1290067948.9091.14.camel@paanoop1-desktop>
References: <1290067948.9091.14.camel@paanoop1-desktop>
Date: Fri, 24 Dec 2010 03:34:52 -0600
Message-ID: <AANLkTimNZraGZNOhMSYH7uko7B2h1KmTg1q2Fsg8NHKt@mail.gmail.com>
Subject: Re: [PATCH] Select R4K timer lib for all MSP platforms
From: Shane McDonald <mcdonald.shane@gmail.com>
To: Anoop P A <anoop.pa@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anoop:

On Thu, Nov 18, 2010 at 2:12 AM, Anoop P A <anoop.pa@gmail.com> wrote:
> >From c872cbbe5f475d3bb3cb7f821270cb466eead1f7 Mon Sep 17 00:00:00 2001
> From: Anoop P A <anoop.pa@gmail.com>
> Signed-off-by: Anoop P A <anoop.pa@gmail.com>
> Date: Thu, 18 Nov 2010 01:33:36 +0530
> Subject: [PATCH] Select R4K timer lib for all MSP platforms

I have successfully booted a 2.6.37-rc6 kernel with this patch applied
on an MSP7120 Garibaldi evaluation board.  It's good to see
PMC-Sierra pushing things back upstream!

Tested-by: Shane McDonald <mcdonald.shane@gmail.com>
