Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1D1DFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:05:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61811 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1D1DFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BEimKAHOcpdLsVkoud4E1od632d6Fy8eCZrMMbMtYqWaHcBGV3l1H3YCVPZuYWZ7u/
         gvkA7KW6FOs6TkwIfhpDhWPiVq0z8Phg5Nd9uSCnQ6qrk+fEu1SS8iV40b8F1YihIl7J
         JHBRNdcmBF8E/kL2/GYre2WBn4jfKSrKkzkKs=
MIME-Version: 1.0
In-Reply-To: <BANLkTin3BmJpuzUyBWV1B38oVMDbXe=fbw@mail.gmail.com>
References: <1303317178.2587.30.camel@mulgrave.site>
	<alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
	<20110421220351.9180.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1104211500170.5741@router.home>
	<alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com>
	<4DB3840F.3060503@gmail.com>
	<alpine.DEB.2.00.1104251355410.31884@chino.kir.corp.google.com>
	<4DB63349.3070808@gmail.com>
	<Pine.BSM.4.64L.1104261049350.4851@herc.mirbsd.org>
	<BANLkTin3BmJpuzUyBWV1B38oVMDbXe=fbw@mail.gmail.com>
Date: Thu, 28 Apr 2011 15:05:12 +1200
Message-ID: <BANLkTimZbC=jFGtA7X_O55yvneekH2oWzQ@mail.gmail.com>
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
From: Michael Schmitz <schmitzmic@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thorsten Glaser <tg@mirbsd.de>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

>> No, this has whitespace problems (tabs are expanded to spaces).
>
> Fixed those up, applied, and will send to Linus for 2.6.39-final.

Thanks, I have no idea how that happened.
>
> BTW, if I enable CONFIG_SLUB on my ARAnyM setup, I don't get a crash, but it
> hangs after:
>
> | INIT: version 2.86 booting
>
> With Michael's patch, it continues fine.

It may just need a long time to crash - forcing e2fsck is a good way
to speed up the crash usually.

May depend on how much RAM you give to ARAnyM, on the kernel size and
any number of other parameters.

Cheers,

  Michael
