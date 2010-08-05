Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab0HEHab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:30:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58783 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759872Ab0HEHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wyRx68LXVOEtShh3cdNpvKmuT2XvcDaQ3s2zlvGWw+B6SPgjWkgW6lpOJFM1O83rSc
         gDX4XrIpZd3ATowje5r4vt9Qsangub44hDyDOcrx145b0PAOuNPTVJtwKZP26gucAyO8
         FSOqtgM0lwb5LgTONgP5Rvhc2Nd/eTROWQLwk=
MIME-Version: 1.0
In-Reply-To: <20100805071235.GA436@morgana.i.gnudd.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
	<AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
	<AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
	<AANLkTi=yJjHDh08muCg7Z97xRGDcTQrv=VimHSNCqn2U@mail.gmail.com>
	<20100805071235.GA436@morgana.i.gnudd.com>
Date: Thu, 5 Aug 2010 09:30:23 +0200
Message-ID: <AANLkTinAuZ5GAauKHfUVV_K_9gQOpFY35m7SLsH6rvD1@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Alessandro Rubini <rubini@unipv.it>
Cc: dan.j.williams@intel.com, peter.pearse@arm.com, viresh.kumar@st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yuanyabin1978@sina.com, ben-linux@fluff.org, kgene.kim@samsung.com,
        rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/5 Alessandro Rubini <rubini@unipv.it>:

>> Peter, Alessandro and Viresh especially: you will hopefully use this
>> driver for ARM refboards, Nomadik and SPEAr, can you provide
>> an Acked-by:?
>
> I'm sorry I can't test it these times, I must delay stuff to
> the last week of August.

That's be a Tested-by: tag, Acked-by: was more about whether you
think it looks sane I believe, see Documentation/SubmittingPatches.

Yours,
Linus Walleij
