Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2JLWRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:17:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38533 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2JLWRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <1350079465.9386.6.camel@trivette.mtl.sfl>
References: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<CACRpkdaaD6HY2o-NNBRZYCXm97Dts7Njzz13Zj7m2ZycV-Ar5g@mail.gmail.com>
	<1349720405.23690.45.camel@trivette>
	<CACRpkdbbungMiZ74o=-CfRoLQj127CaWaYr7adKKSquFd=x5qg@mail.gmail.com>
	<1350079465.9386.6.camel@trivette.mtl.sfl>
Date: Sat, 13 Oct 2012 00:17:09 +0200
Message-ID: <CACRpkdYRPVw1YTZQ7QfX=8Zm-0MN_QQ5UAPabAr=E5Lc0sG9GQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: add TS-5500 DIO headers support
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 12:04 AM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:

> About the generic driver (to allow registering one platform device per
> DIO block), I think it won't be possible, because there are shared
> regions, such as 0x7d, used by DIO2 and LCD DIO for direction...

Probably true.

> Is there a way to share this, or does this mean that this driver should
> handle the 3 blocks as it already does?

I think you should try to handle all 3 for the moment atleast.

Yours,
Linus Walleij
