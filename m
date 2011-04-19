Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1DSRH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:07:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65219 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1DSRHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vzVFGI1iaSIxV7jgwAp1kD8oZw+Owa0W+WOUOzjG/i5L7Ro6uuavZEIyzXWtULM1tC
         udCTY/qC+yRzRA825vTKAQksPBBvSqQ1WM3AgUqKNMZwvSStAnbMTB94n6dwHl1byfSO
         754jkaQ4xr33ZYg3AUVQKLwfEgodBiCtWRsJM=
MIME-Version: 1.0
In-Reply-To: <BANLkTin3rQangWB+G0Y_FDK5RgqESDihrA@mail.gmail.com>
References: <20110410020923.GI4663@erwin>
	<BANLkTink1mKJMccy1bLdkYsh5XBvDF4sSw@mail.gmail.com>
	<20110410143153.GJ4663@erwin>
	<4DAD5BCB.8010604@suse.cz>
	<BANLkTin3rQangWB+G0Y_FDK5RgqESDihrA@mail.gmail.com>
Date: Tue, 19 Apr 2011 13:07:24 -0400
Message-ID: <BANLkTi=vdpzxbu_r1cnRHJTR+_J3FHwafQ@mail.gmail.com>
Subject: Re: [PATCH v2] kconfig/kbuild: define _POSIX_C_SOURCE
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Valentin Ochs <a@0au.de>, Roman Zippel <zippel@linux-m68k.org>,
        trivial@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 19, 2011 at 1:03 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> diff --git a/Makefile b/Makefile
> index d6592b6..0490413 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -233,7 +233,7 @@ CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then
> echo $$BASH; \
>
>  HOSTCC       = gcc
>  HOSTCXX      = g++
> -HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2
> -fomit-frame-pointer
> +HOSTCFLAGS   = -D_POSIX_C_SOURCE=200112L -Wall -Wmissing-prototypes
> -Wstrict-prototypes -O2 -fomit-frame-pointer
>  HOSTCXXFLAGS = -O2
>
Sorry, gmail wrapped long lines, the relevant part is only:

HOSTCFLAGS+= -D_POSIX_C_SOURCE=200112L

 - Arnaud
