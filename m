Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1D2HZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:25:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43576 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1D2HZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JSPOcQ8IFLksOyAyIApglfMBZqBtwYmWtpw/5JpWVn9biV6ajTuue0uqaANB1zFhcS
         JVnUpxLEm441W0SIJ3X2agRRpA8YetNS309l9d0aaSCOlOIpl024lZ/XRXoyMmQDcyqE
         5JR6NyPOY0tOM7WC2jfT20aEbqmURKjAcp+HA=
MIME-Version: 1.0
In-Reply-To: <20110429115948.e949234b.sfr@canb.auug.org.au>
References: <20110429115948.e949234b.sfr@canb.auug.org.au>
Date: Fri, 29 Apr 2011 09:25:13 +0200
X-Google-Sender-Auth: vF4R1s4uimmVn_uG4LSDk3jQMAA
Message-ID: <BANLkTikJ5CVvS+P17T_Mhtqyb29vpDcmvw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the ux500-core tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/29 Stephen Rothwell <sfr@canb.auug.org.au>:

> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/mach-u300/gpio.c between commit 4a5a6e2804a3 ("mach-u300:
> rewrite gpio driver, move to drivers/gpio") from the ux500-core tree and
> commit b0c3af5ef0d7 ("arm: mach-u300/gpio: Fix mem_region resource size
> miscalculations") from the trivial tree.
>
> The former removed the file updated by the latter.  These updates should
> be applied to drivers/gpio/u300-gpio.c, now.  Joe, maybe you could update
> your patch and send it to Linus Walleij.

I rewrote the driver completely so likely it will rather be dropped, but
please check! I'll be happy to carry any patches.

Yours,
Linus Walleij
