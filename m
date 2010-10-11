Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0JKN5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:57:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab0JKN5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C4cwayZaDrcAkSXu+uSOSdedPQNU0EbyVWK4On510cUFfT1vZra5H8TR4AiYRfgl83
         7c6heRk9nR2xEKqUBzghXFNJbTLW16yXO/d9ENqMsMbzSD8mTJeOZt96RFlLhjwtqKAp
         G4FNJ9SnWBMsZ+hNQVeVey7NCUo8UKrbUnTBU=
MIME-Version: 1.0
In-Reply-To: <20101008002244.GA6523@suse.de>
References: <201010072140.o97Le69i025659@imap1.linux-foundation.org>
	<AANLkTi=UgODY9REO-f9hxRBT4iZqsFB2spdBTCqeUTk4@mail.gmail.com>
	<20101008002244.GA6523@suse.de>
Date: Mon, 11 Oct 2010 09:57:38 -0400
Message-ID: <AANLkTi=Fmp_J5exsJReMoAVSaadFUDYjPUPUgd_qOCv0@mail.gmail.com>
Subject: Re: mmotm 2010-10-07-14-08 uploaded
From: Bob Beers <bob.beers@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, resend without html (gee, thanks gmail >:\)

On Thu, Oct 7, 2010 at 8:22 PM, Greg KH <gregkh@suse.de> wrote:
>
> On Fri, Oct 08, 2010 at 02:17:54AM +0200, Zimny Lech wrote:
> > Hi,
> >
> > 2010/10/7  <akpm@linux-foundation.org>:
> > > The mm-of-the-moment snapshot 2010-10-07-14-08 has been uploaded to
> >
> >   LD      drivers/built-in.o
> > drivers/staging/built-in.o:(.data+0x2490): multiple definition of `max_mtu'
> > drivers/infiniband/built-in.o:(.data+0x6b30): first defined here
> > make[2]: *** [drivers/built-in.o] Error 1
> > make[1]: *** [drivers] Error 2
> > make: *** [sub-make] Error 2
>
> This is a cxt1e1 driver issue.
>
> Bob, care to fix this up?
>
> thanks,
>
> greg k-h

Hi Greg,

Yes, I will.

It appears in 4 files, a total of 12 occurances.
I guess it is enough to rename it, perhaps simply add a cxt1e1 unique prefix?

-Bob
