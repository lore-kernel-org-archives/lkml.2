Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0HRNjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:39:43 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59083 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0HRNjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pd0/xVEy/W979535yzZgl2LkAE2+L+Isjqutv+Gz851O4rqYQzzZzKBfiVFnWN/ltc
         AIxsE13wwfGoQG4VJlwvhNw8gEJvrGWOSmcHrMoFVj4d1v4eJVNbfwPFOpklpOvMIu81
         30rqIPHFFkdZrpGLAd14Trct7xMdNILVO2Ar0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=vCb8rQu3KPcCv7cP94ovQ_ZFrs7aBjGYtPQmy@mail.gmail.com>
References: <1281095419-15600-1-git-send-email-linus.walleij@stericsson.com>
	<20100817044834.GA27060@angua.secretlab.ca>
	<AANLkTi=vCb8rQu3KPcCv7cP94ovQ_ZFrs7aBjGYtPQmy@mail.gmail.com>
Date: Wed, 18 Aug 2010 15:39:40 +0200
Message-ID: <AANLkTinmYR_N2jv1q7rNR1FWvemXbemkhJBL=_f9eFP0@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: add PrimeCell generic DMA to PL022 v9
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/18 Grant Likely <grant.likely@secretlab.ca>:

> This patch causes the following build error and warnings.  The
> warnings are simple init annotation mismatches.  I haven't dug into
> the error, but I suspect the driver needs to depend on or select
> another config symbol.  I'm dropping it from my tree.

I'm unable to reproduce this problem in Torvalds' tree and
-next. I'm using the realview, U8500 and U300 defconfigs with and
without the DMAengine, no difference, totally silent.

What kind of configuration are you building this on?

Yours
Linus Walleij
