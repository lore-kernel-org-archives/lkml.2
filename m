Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab1EJXyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:54:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1EJXyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=R2fxe6a8IRfEdvlqfZGwt1cJD2U8+6h7d/0SQs1Qddp6+Z9epqtomhuE621PIt+jhq
         fDrekIOj6yvjEuGkOMAUiZJ4kjYSEuyIqNwdhtkcOnOeNBUZAnFM5106jdoOdMx78tk7
         NAz1nz9ex476LSLfwpteCkJCeo+7AbNYmHNMk=
MIME-Version: 1.0
In-Reply-To: <20110510055926.GA2747@redhat.com>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
	<201105061522.33179.arnd@arndb.de>
	<20110510055926.GA2747@redhat.com>
Date: Wed, 11 May 2011 01:54:10 +0200
X-Google-Sender-Auth: jhY2P9R9yXeCohuuz-XCicILwnQ
Message-ID: <BANLkTim0uKnjhKdVookDY0LPfaoQFy_TRQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] mach-ux500: update and move cpufreq driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dave Jones <davej@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/10 Dave Jones <davej@redhat.com>:

> Haven't had chance to really read much patches the last few days
> (travelling until the 16th).  Due to the patch collisions we'll keep
> seeing on kconfig/Makefiles, should these go via the cpufreq tree,
> or do people want to still push them through their respective arch trees ?

In this specific case it will likely have to be through my tree, since I'm
not just messing with the cpufreq driver but also the thing it is using
for communication proxy, i.e. the PRCMU MFD driver.

I'm mainly after seeing if it's in shape to be pushed into drivers/cpufreq/*
and then I will be rebasing and requesting Linus (Torvalds) to pull this
after your cpufreq changes are gone in first.

So right now I'm looking for ACKs.

Thanks,
Linus Walleij
