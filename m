Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1DNWDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:03:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49358 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1DNWDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=weFeozT0386LDUmKL80zri3lJuFXZaFvJEUOA1iyjSKBZovpDML4/dpSzkrAf/YOUR
         bXGJ0V6vzd5D2Yzh7aSJvZ2yR3xlDLuNELlnQ7SvdH7A8MS1d19Cg3+gb3Qe/aqWgicu
         SJwnlZbQ0vg3eUEhSUbJEC+NnSXpeAz2kcmhI=
MIME-Version: 1.0
In-Reply-To: <4DA75EA9.4050602@ece.ntua.gr>
References: <BANLkTim-KC7qfijD5rFNTR98GSs=cTPzJw@mail.gmail.com>
	<4DA75EA9.4050602@ece.ntua.gr>
Date: Thu, 14 Apr 2011 19:03:39 -0300
X-Google-Sender-Auth: LnfcrMq12VBVAYYi3AQ0iDxXFzk
Message-ID: <BANLkTim9iAM=d-aWxKySJTsUjvOyVLD0=A@mail.gmail.com>
Subject: Re: [REGRESSION] 2.6.32.36 - Linux Xen DomU doesn't boot anymore
From: "guilherme m. schroeder" <guilherme.m.schroeder@gmail.com>
To: Stratos Psomadakis <psomas@ece.ntua.gr>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 5:52 PM, Stratos Psomadakis <psomas@ece.ntua.gr> wrote:
> Can you try 2.6.32.37-rc1?
> The patch you're referring to was committed I think along with another
> patch which caused some trouble in the -stable trees(I'm not surea bout
> that though :/).
> And in 2.6.32.37-rc1 it was reverted:
> [59/74] [PATCH] Revert "x86: Cleanup highmap after brk is concluded"
> Maybe it fixes your problem.
>
> --
> Stratos Psomadakis
> <psomas@ece.ntua.gr>

No problem with 2.6.32.37-rc1.
Do I need to bisect 2.6.32.37-rc1 against 2.6.32.36 to make sure it is
the patch that you mentioned?
And if we find it, there'll be a 2.6.32.36.1 release or we need to
wait for 2.6.32.37?
I'm asking this because some distros are already taking 2.6.32.36
(Debian 6.0 proposed kernel for example).
