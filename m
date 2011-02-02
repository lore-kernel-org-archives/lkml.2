Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1BBPi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 10:38:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57089 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab1BBPi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 10:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xha2rHtCmVrmJN6VnElfokrS54QGq+XyieWL4fgGzwj6QoJd58/IfRtU/drtDb2Iir
         DQPCUkxw8tokDgxusrmcfBNKeV/RRUqbjwur8qv1cXSdl0/21XBIUcWRCVjpoYImIsw8
         jLXocZ+T1QGXor8GB1CuB6rGwvHWcQs8514k4=
MIME-Version: 1.0
In-Reply-To: <20110202144924.GD9810@sirena.org.uk>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
	<20110202144924.GD9810@sirena.org.uk>
Date: Wed, 2 Feb 2011 16:38:26 +0100
X-Google-Sender-Auth: LwAs2hVsIBp7PniPgOGwjY9Oirc
Message-ID: <AANLkTi=h0MyXXrHtxeeDvY1gja48UeK-Hi=b5nbf4ug5@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 15:49, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Feb 02, 2011 at 03:05:16PM +0100, Geert Uytterhoeven wrote:
>
>>       src/drivers/regulator/wm831x-dcdc.c: warning: control reaches end of non-void function: 124 =>
>
> Either your compiler or architecture isn't noticing that BUG() can't
> return.

This one was listed under "improvements", i.e. it got fixed between
v2.6.37 and v2.6.38-rc3.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
