Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1EPJCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:02:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50645 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1EPJCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=idCnPQTZOSaL7QUIXSK5GRvMIc80jyev0Ugb4AOp1bDrUa9wkJc6Z1qcF8SZwvVS7y
         wMBjjsJXDRG8OW7AjMOivUMvp6p47HWRZ5KvYRQwYcKtPmVPghaNk9FoQGa0IkZzTqeF
         BwH06WSYgM2vzM6pUuoOXpasBUshJFG0Yq7PM=
MIME-Version: 1.0
In-Reply-To: <20110510055926.GA2747@redhat.com>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
	<201105061522.33179.arnd@arndb.de>
	<20110510055926.GA2747@redhat.com>
Date: Mon, 16 May 2011 11:02:14 +0200
X-Google-Sender-Auth: nmRMs8-m0yHqefIQZl3A9JWaL-c
Message-ID: <BANLkTimh2Xaz73v-2c0GmcS9wD4+JFWzrw@mail.gmail.com>
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

I pushed a patch series yesterday that basically deactivates the
cpufreq driver in the mach-ux500, moves it over to drivers/cpufreq,
updates it, then reactivates it in the new place with a patch to
the Makefile.

Of these changes only the last patch will collide with your tree,
so I pushed all of them except that one to linux-next.

The last patch I plan to submit to Torvalds directly after both
trees have gone into the merge window.

Can you please look into this and ACK the patches if they
seem OK?

Linus Walleij
