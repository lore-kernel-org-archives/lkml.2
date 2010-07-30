Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab0G3R2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:28:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34362 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab0G3R2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pdAGxoOj0Rl+r/q01rLplNwaz+43F+gUS+RfK1ipRVuo56jQKKlmqdPykhgxsXev0W
         yCDrLik1+uNWuOnLLp+A1RWJxokhOFslEnSJBmghSDNpCnsSuRS1MJVdK34BpFbrPQQb
         MkhpjZTcBQCy9c82DpAaTaw9CLcYKHcu80NTg=
MIME-Version: 1.0
In-Reply-To: <1277194762-21399-1-git-send-email-rabin.vincent@stericsson.com>
References: <1277194762-21399-1-git-send-email-rabin.vincent@stericsson.com>
Date: Fri, 30 Jul 2010 19:28:44 +0200
X-Google-Sender-Auth: e_ytVLszR0kKh_M2gg7W4fXQd2g
Message-ID: <AANLkTin-EGaq9q0ATgRfm=XKTgJ7EYT_Q-Ruzr_OQXsY@mail.gmail.com>
Subject: Re: [PATCH] mmc: only set blockaddressed for > 2GiB cards
From: Linus Walleij <linus.walleij@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/22 Rabin Vincent <rabin.vincent@stericsson.com>:

> From: Hanumath Prasad <hanumath.prasad@stericsson.com>
>
> A non-zero value of SEC_COUNT does not indicate that the card is sector
> addressed.  According to the MMC specification, cards with a density
> greater than 2GiB are sector addressed.

What's happening with this beauty? Andrew would you mind
picking this one up please?

Yours,
Linus Walleij
