Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0I1FC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 01:02:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61159 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0I1FC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 01:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=KZvuXosX6FRnSXiuGvaJOVgqEjg0InuoH6Kn/JHOCKHsukmsJ/EJkkLmb15e3YPLO2
         ysAboNjnu7F8XmNufzOHaDN3pyoNpzevqFXrXUWp6IL0hVqQxRj6ud+JsY0JDj3zpWhc
         w/0C2DzskG7LSC89Adhu3+nlzC+7il/6TY+gw=
MIME-Version: 1.0
In-Reply-To: <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main>
 <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com> <201009272338.23762.vapier@gentoo.org>
 <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 28 Sep 2010 01:02:35 -0400
X-Google-Sender-Auth: RCIrcW-nsnQjZ26I97YQ8zz21UA
Message-ID: <AANLkTikUJMfo8m8o1rQdf264g2P39uHLRp80vGPW0Jni@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 00:57, Masayuki Ohtake wrote:
> I have modified for GPIO standard I/F referring other accepted GPIO driver.

no idea what this driver is

> According to Documentation/gpio.txt,
> I tried to create GPIO node like below.
>
> [root@localhost gpio]# ls
> export  gpiochip244  unexport
> [root@localhost gpio]# echo 1 > export
> bash: echo: write error: Invalid argument
> [root@localhost gpio]#
>
> But it fails.

find out what range of GPIO numbers your driver is using and use those
instead of "1"
-mike
