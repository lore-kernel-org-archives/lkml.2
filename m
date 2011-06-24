Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab1FXOuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:50:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456Ab1FXOuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DFJsrYvXwjDRhQf3wjgguR7Qi65U8Zfj1kMOVQYK1U9hZUV40N7WGS4GYPR0ZOZfjV
         irD8fqfHfWv7mviu+vJK2mljqWumhm9Rxas+YF3fUWLkp4gfJ9lnWzslSXRnmPLRkC4g
         4/a3ygB8OhJnSn2Tzd/9RZ5O2ApjtGyaLzn/c=
MIME-Version: 1.0
In-Reply-To: <20110624161029.e8f96175.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
	<BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
	<20110618183029.822f4d82.sfr@canb.auug.org.au>
	<20110623212736.74bea79a.sfr@canb.auug.org.au>
	<BANLkTimoWrwPNNYrLFN-_gyPnvSCEa9ksA@mail.gmail.com>
	<20110624161029.e8f96175.sfr@canb.auug.org.au>
Date: Fri, 24 Jun 2011 16:50:11 +0200
X-Google-Sender-Auth: Xy6VzTPOG1wM6t7jHOPm4L68wPY
Message-ID: <BANLkTinixfckRaUmnPWJ2oObJALjv-7p8g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Jun 24, 2011 at 08:10, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 3.0-rc4 should be complete in a few hours.  Hopefully rc5 will be faster.

Completed at 101% 108/107! :-)
But there are only 107 logs on the page.

Anyway, the "-k" seems to work: much more problems in the logs. Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
