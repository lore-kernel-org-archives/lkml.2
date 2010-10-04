Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0JDXd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:33:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39961 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0JDXd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sPFlNO+zx0yJpH95THRrrv/OdXfx155s6sObK+cM0on9AyWn1BAz39WJjAHY6/2zmm
         n4J/KMmXjZzdBH4qq4Uip4KE7xlJPpwh4kgsOx8QXzpr/p5W09jKy2JejZ+4l/ruieE6
         FEWleb2sf+hyPaUMRy9riQPrVUMGKbqdiYs/o=
MIME-Version: 1.0
In-Reply-To: <20101004161600.8cdf4e0c.akpm@linux-foundation.org>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>
	<4CA4D61C.2010909@gmail.com>
	<4CA4E76E.1050602@gmail.com>
	<20101004161600.8cdf4e0c.akpm@linux-foundation.org>
Date: Tue, 5 Oct 2010 01:33:25 +0200
Message-ID: <AANLkTimmQmQU4fE9ku_wc8x_dPEfnjgOHWSM18O0=coa@mail.gmail.com>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/5 Andrew Morton <akpm@linux-foundation.org>:
> Removal of duplicated includes is a somewhat dangerous thing.  If
> someone else says "hey, there's a duplicated include" and then fixes
> it, and if this patch removes the other include then whoops, we broke
> the build.  This has happened before.

Yeah, right.

>
> So I'd ask that you redo and resend this patch shortly after 2.6.36 is
> released please, so I can get it into mainline quickly thus minimising
> the opportunity for such breakage.

Ok. Do you want patch against 2.6.36 mainline, -next or -mmotm?

>
>> Signed-off-by: N.P.S. <napohybelskurwysynom2010@gmail.com>
>
> We prefer that signoffs have real names in them, please.
>

Do "Zimny Lech" sounds real enough? :)

-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
