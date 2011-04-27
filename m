Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1D0I2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:28:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64967 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab1D0I2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xSm6JvLOEV5JdpHQMsvcHKJY9yGuROk6qmP3z09/Hi/UhQR2J8pp2h2QU5FeGbtT7H
         DRDsrrBRhec1JXd+mr6tQQbbI+IV7FmdVCg2gnHVkKWaNkDCqMA+mSziLKpzkrHEmCPc
         kE3BVXQQCr6fiXfT9qWRv/lBk3BjlAQRkfQdw=
MIME-Version: 1.0
In-Reply-To: <20110422104646.GB8324@liondog.tnic>
References: <20110422102028.GA8324@liondog.tnic>
	<20110422104646.GB8324@liondog.tnic>
Date: Wed, 27 Apr 2011 10:27:59 +0200
X-Google-Sender-Auth: 9jcD6GUmOUmJ_uBt6gcPUDsQIDY
Message-ID: <BANLkTi=uk1LK0Arjx9cgbE==aUw1kNWhkg@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: implement several W= levels
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, Dave Jones <davej@redhat.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 12:46, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Apr 22, 2011 at 12:20:28PM +0200, Borislav Petkov wrote:
>> But seriously, let me add my comments to your patch while they're fresh
>> in my head and let's see what we come up with in our combined and
>> perfectly orchestrated effort :).
>
> Ok, this is starting to look like another kernelnewbies.org task:
>
> make W=x 2>>w.log
>
> and stare at compiler output in the other xterm:
>
> tail -f w.log
>
> and the bugs are just waiting there to be fixed! :)

You can use http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/linux-log-summary.pl
to get a summary, sorted by number of occurrences. So you see which
ones to fix first ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
