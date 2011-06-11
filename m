Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1FKLj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 07:39:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47667 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab1FKLjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 07:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lwcCMT8AZ+3HRX6/F0znlwG/tnlXXPBvUQe/Ci/nLPh1ni/LDFbpLvX+aUMjYoypEV
         0rXP7Y5YEmbh53anokCsNhRKRDx34LV8EOvCQWiOVUl0y/EA0cxD0kiWLozY4UPCz9cR
         JHxPSbv87Fd6k43/Mp8mx+x2ZouqcQO5cmDqc=
MIME-Version: 1.0
In-Reply-To: <20110611142648.bf71b026.sfr@canb.auug.org.au>
References: <20110609145657.96fae0d0.sfr@canb.auug.org.au>
	<BANLkTi=fn1qxcJGs7Ngag6ph2uMECiyWLg@mail.gmail.com>
	<20110611142648.bf71b026.sfr@canb.auug.org.au>
Date: Sat, 11 Jun 2011 13:39:50 +0200
X-Google-Sender-Auth: aHKeh7Y9lR3zX4_pFpXguT_2M3g
Message-ID: <BANLkTinuDJNRDr9eAiyr4busLr4jiLvC1w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 06:26, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 10 Jun 2011 22:28:03 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> My first bisection between two successive versions of linux-next failed, but
>
> Bisecting between successive linux-next versions is bound not to work.
> Bisection really only works between a commit and one of ist ancestors.

Yeah, I should have known that...

>> the second one between linus and linux-next just finished and points
>> to that commit.
>
> That is a much better bet.

Patch has been sent.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
