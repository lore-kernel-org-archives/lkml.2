Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0FWW2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:28:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47854 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab0FWW2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=NyYEbyfcj/dTCpMZsrx8DaTHYgRrsO/nSQyo7XO4ShKTVCoJWwkFf7xjzM/8v7NniY
         eT//H+vdjBpRxvxZN3ZzOlYswudfFATOazjqNhjnocK5x9do9rzdMVZAK9kyVDbz99AR
         TWQQJCdu6Jz4cHFghR7pE1YemPMODgvH7eiog=
MIME-Version: 1.0
In-Reply-To: <20100621063552.GA16491@liondog.tnic>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
	<rHrHQMIU4rI.A.h6.rapHMB@chimera>
	<AANLkTiks4DUvSLQLHb1Tr6cO_Mma-9UcDRqJ5uafdt1R@mail.gmail.com>
	<20100621063552.GA16491@liondog.tnic>
Date: Wed, 23 Jun 2010 18:28:18 -0400
Message-ID: <AANLkTintzv8areadp7DJO5qdq_V6ZdTmZb5MNnCWzzDs@mail.gmail.com>
Subject: Re: [Bug #16054] UML broken for CONFIG_SLAB
From: Parag Warudkar <parag.lkml@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Parag Warudkar <parag.lkml@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 2:35 AM, Borislav Petkov <bp@alien8.de> wrote:
> From: Parag Warudkar <parag.lkml@gmail.com>
> Date: Sun, Jun 20, 2010 at 06:48:55PM -0400

> make mrproper
>
> and just to make sure no arch_hweight stuff is left, do
>
> grep -EriIn 'x86.*hweight\.h' arch/um/
>
> You shouldn't be getting any matches. If you do, than try to find out
> why you do because all those intermediary *.o.cmd files shouldn't
> contain any hweight-include files from arch/x86/.
>

Ok. That solves the cfq related crash due to hweight stuff. However
the second issue - UM is broken for CONFIG_SLAB still exists.
So I think we can keep the bug open.

Thanks

Parag
