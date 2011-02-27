Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab1B0SUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 13:20:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35678 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1B0SUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 13:20:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FMN2ox1nRGr0zsQtAXk1SKxlEkajbgPRR3eyz0Fk9ls7MHe9NnMfTU9JZCKkQBu5VM
         5fUs6USGQqpPezybnbPuWNs/lyuWSdbOjFuBmhHfTKnHHw0YLkZYUElcGPLjJstHKlPd
         Z6lBeWdpIhpkBO0lFQbOTPAcsF4IZZ+zSo8I0=
MIME-Version: 1.0
In-Reply-To: <20110202182013.GA2924@pengutronix.de>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
	<20110202182013.GA2924@pengutronix.de>
Date: Sun, 27 Feb 2011 19:20:08 +0100
X-Google-Sender-Auth: q_37vRRDZLpDohivcJhMQlU2lAM
Message-ID: <AANLkTinXQmTmQCchYzGSdGah9ww2tnwY+6WFDXGTuCpb@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 19:20, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Wed, Feb 02, 2011 at 03:05:16PM +0100, Geert Uytterhoeven wrote:
>
>> Below is the list of build error/warning regressions/improvements in
>
> Is it an idea to prefix regressions with "+" and improvements with "-" (so it
> looks a bit like a diff)? In those long lists, it is quite easy to overlook
> where you currently are.

Thx for the suggestion!
As you probably already noticed, I started doing that.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
