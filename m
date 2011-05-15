Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1EOX4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:56:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1EOX4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tjL/EYntepJEHU2tttDzzsT3ZonJT6np3AsGwTVDLeMcqlkWY7whMYoNmc7PBJpr4d
         6taPUgUzddJKc55U9a6lUG8Yh40L6wflu/aUypKCAwyepqUARSAbCRi4I7eN+rDW4gLo
         +VAjOKPMJUFWnWLOQqJCaZmZ5L4V32dL2QIKg=
MIME-Version: 1.0
In-Reply-To: <20110511024709.GA16868@kryptos.austin.rr.com>
References: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
	<20110511024709.GA16868@kryptos.austin.rr.com>
Date: Mon, 16 May 2011 01:56:47 +0200
X-Google-Sender-Auth: Mfg--LuW_3CYOGfJyhGtKYPhMzI
Message-ID: <BANLkTimNO+XBDajGMVNZi-yD0v2ufq-=5w@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Josh Cartwright <joshc@linux.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/11 Josh Cartwright <joshc@linux.com>:

>> +out_no_memregion:
>> +     release_mem_region(upmx->phybase, SZ_4K);
>
> release_mem_region(upmx->phybase, upmx->physize); ?

GOOD CATCH!

Thanks Josh!

Linus Walleij
