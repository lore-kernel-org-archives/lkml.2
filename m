Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab1FJU2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:28:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab1FJU2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i6nGNou1NGKgJ5TYE28C40l6aMhQepM/MGSRDCIUJ1Iso7KJyE7r+gytekbbxkm+f8
         mBNH8QQfnMD7/GTGmKpC0vSUEQc2EfGP35BrC3WHuBqHXUbNvg1RTidr5IukzXjMJMVn
         nlTxTifEB+HE6FV+sGxtbjzYoUicRA6FzmH1I=
MIME-Version: 1.0
In-Reply-To: <20110609145657.96fae0d0.sfr@canb.auug.org.au>
References: <20110609145657.96fae0d0.sfr@canb.auug.org.au>
Date: Fri, 10 Jun 2011 22:28:03 +0200
X-Google-Sender-Auth: FzBJdeCsR2DdJ8pY3JbHAp1sQ1g
Message-ID: <BANLkTi=fn1qxcJGs7Ngag6ph2uMECiyWLg@mail.gmail.com>
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

On Thu, Jun 9, 2011 at 06:56, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> I assume that this is fallout from commit a6b7a407865a ("net: remove
> interrupt.h inclusion from netdevice.h").

Ah, that's were the failures on m68k come from:
http://kisskb.ellerman.id.au/kisskb/buildresult/4222666/
http://kisskb.ellerman.id.au/kisskb/buildresult/4223000/

My first bisection between two successive versions of linux-next failed, but
the second one between linus and linux-next just finished and points
to that commit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
