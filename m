Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab0HEVlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:41:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49549 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab0HEVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uiI2HeVBS6lNK7B144kjOH1LB24Bb/2woleLvU0riAuqruTSrfH8PGRfBL4RiCUnyi
         /Dl6eHwEb2ma8asq0MXNyAOERK39VGqSbH7WXGk4Gx8BF7K7lg/L0t3sif4p3QtBuK0K
         osvuUrFGSGVfoVQ5eU6NbhpnQyCvBV9VTGHx4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1008052235400.31692@ask.diku.dk>
References: <921858.63779.qm@web180313.mail.gq1.yahoo.com>
	<Pine.LNX.4.64.1008052235400.31692@ask.diku.dk>
Date: Thu, 5 Aug 2010 23:41:03 +0200
X-Google-Sender-Auth: 08fYlCuqQ9gmEPvP9CTDdqKibbw
Message-ID: <AANLkTinCCrrdEXMTdPiFp4Y4gE4zqNVYQZFFSXWEmH-r@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 26/42] drivers/spi/amba-pl022.c: 
	Adjust confusing if indentation
From: Linus Walleij <linus.walleij@stericsson.com>
To: Julia Lawall <julia@diku.dk>
Cc: David Brownell <david-b@pacbell.net>,
        spi-devel-general@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/5 Julia Lawall <julia@diku.dk>:

> From: Julia Lawall <julia@diku.dk>
>
> The return -EINVAL appears to only make sense if the if branch that it is
> aligned with is taken, so move it into that branch

What a nasty bug to see, thanks for robot-finding this!
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
