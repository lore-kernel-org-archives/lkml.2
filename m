Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0L3Tkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:40:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48777 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0L3Tkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 14:40:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=uycbrvONHHq8B5xR+mmX2jBe5RbOeh1xftJvpXR+GCZUpIFyug0ltJn1f2hIDV3hht
         +pn7HopuPrDr+rBtpXYYT7cWMI4CYMkh7wxXr8v98bGXTt9M3ePo3X54Bq/KROhig7X1
         glH76IM0m6/3Wk0lcuVR5gvWLKnQsn0k4NJQw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1012232128380.6624@ayla.of.borg>
References: <alpine.DEB.2.00.1012232128380.6624@ayla.of.borg>
Date: Thu, 30 Dec 2010 20:40:34 +0100
X-Google-Sender-Auth: aPynUWjLlyGZMsJ7ondmdQ0QB5o
Message-ID: <AANLkTi=Qp3vRSFEC4bjdKJWCvWD_BgQmud6NOVdFurYp@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.37-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 21:28, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Note that there may be false regressions, as some logs were incomplete.
> Still, they're build errors/warnings.
> In fact, compared to v2.6.36-rc5 or v2.6.37-rc3 (2 previous releases with full
> coverage of the 108 configs), there are no regressions at all, which is good
> news!

Sorry for giving you all this warm feeling inside. I screwed up and
used an incorrect
command line :-( So yes, we still have new build regressions...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
