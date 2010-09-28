Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0I1Fcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 01:32:43 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60832 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0I1Fcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 01:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=tJWUDV9+/vGMj1DFZzMFO8pIkmThR8i8JgIEWVSFgGbwi0Vs7KbU3OMSaX1QmQIHYw
         Ima3vaZJ5yxT/BH/gxU5Ncv9VWhwUyrqAWZZEMlFclzUrG7+gJZuyPznPgXnWqC9bBow
         fR2ZbCvB1+t9XQpb05V/SHklrLmwN0tzghfgw=
MIME-Version: 1.0
In-Reply-To: <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main>
 <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com> <201009272338.23762.vapier@gentoo.org>
 <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com> <AANLkTikUJMfo8m8o1rQdf264g2P39uHLRp80vGPW0Jni@mail.gmail.com>
 <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 28 Sep 2010 01:32:20 -0400
X-Google-Sender-Auth: bQ0dSTlEn1gUCPpaAEc2uH-4xfw
Message-ID: <AANLkTi=PvwA81YiZszUu2B=rDoBhduJwdWv2CrYWWu+f@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        richard.rojfors@mocean-labs.com, meego-dev@meego.com,
        ML linux-kernel <linux-kernel@vger.kernel.org>, Qi <qi.wang@intel.com>,
        andrew.chih.howe.khor@intel.com, gregkh@suse.de,
        Yong Y <yong.y.wang@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, joel.clark@intel.com,
        margie.foster@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 01:25, Masayuki Ohtake wrote:
>> find out what range of GPIO numbers your driver is using and use those
>> instead of "1"
>
> I have attached a part of our source file.
>
> Since I set "ngpio=12",
> I guess 0-11 can be used, thus, "echo 1 > export" should be success too.
> Is this true ?

there are often multiple gpio sources in a system.  whichever one is
registered first (usually the arch/cpu specific one) tends to start at
0.

i'm merely providing generic gpio information.  i know nothing of your
specific arch/cpu/board setup.  you'll have to do some
digging/debugging on your side.
-mike
