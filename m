Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1BHMHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:07:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64313 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1BHMG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ajAy8Wpsm2ieaALhy9X6hiM7t5geeLIsMQkp1AuDG3myRANKAhihu0bSx6i6nbtvVS
         dFKg9S9xexjYzQkIiYbv4tPh7cLulwl2/lWPXp1Z8nrL7PqqFi4wC3G37vrsFVd9riyp
         JDEVQtl49ekgCav6ihQ17H1DW8FsmSOkmFN7Q=
MIME-Version: 1.0
In-Reply-To: <4D511FA7.4040207@samsung.com>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
	<20101208115510.GD10998@console-pimps.org>
	<AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
	<AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
	<20101209064751.GA21128@void.printf.net>
	<AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
	<20101209160157.GA28586@void.printf.net>
	<AANLkTim3Rj2tTbqvT8nM4L=p=Wx8bdOnGq=EDv+cs02g@mail.gmail.com>
	<20101211192320.GA24430@void.printf.net>
	<AANLkTik7cMwgwXR1zK44HXC+1YtzpU3_zW2GUjcBMi8X@mail.gmail.com>
	<4D354752.3030401@samsung.com>
	<AANLkTi=SEXYk9B6N6RGmLKAx_QF6sybgHMVVpEo8mcp8@mail.gmail.com>
	<4D50E4DD.4030500@samsung.com>
	<AANLkTikTxjbkA9d9WjVNm9bC3bPLQDndwSXCxp3jOLKS@mail.gmail.com>
	<4D511FA7.4040207@samsung.com>
Date: Tue, 8 Feb 2011 12:06:57 +0000
Message-ID: <AANLkTimuC1yu6ggeM3TEwzdsfGV8+=_=y5JzSEfRmBwU@mail.gmail.com>
Subject: Re: [PATCH v4] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 10:49 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Will
>
> I'm probing dw_mmc on Samsung SoC...
>
> So i have some board specific data..
>
> But i didn't want to add board specific data in dw_mmc.c
> I want to use get_cd()/get_wd()/init()...So i asked to you..:)

It may be possible to use your board specific data in your callbacks
directly rather than passing the board data to the driver and passing
it back, although it depends on the structure of your code.

> If i need not the data information, i will not append them..
> you're right, maybe "struct dw_mci" need not..(just example)
>
> And i think that need card_detect irq-handler function..if we use pdata->init..isn't? :)

I think the use of pdata->init should be made optional, as it doesn't
seem to be needed on most SoCs.

> In future, if i need your help, can i ask to you?

Yes, certainly. We continue to work on the driver and would be happy
to have our bugs fixed! ;-)

> Onemore...Did you test the dw_mmc..?
> If you can answer, i want to know the performance..

We have tested it, unfortunately I don't have any accurate performance
figures to hand. The perform seems to be in the expected range though.
