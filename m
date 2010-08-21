Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab0HUWah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 18:30:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62872 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0HUWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 18:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S5t/2oS8+wnlOfxXra0hdmjHhb+PndeQ7dXfjbUFBTmwayGhHgIh4nVD2m99rXIDe5
         sF/Ys8RwFlo/I1/gwdkmKYONG/L4nFNDhi68Y5ougvBUPgtBDAbobSqfEUfU5Sj9rtEJ
         lVypwmWKfsFTSUaFpf8kjX1asZHdXNkxyg1hA=
MIME-Version: 1.0
In-Reply-To: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
Date: Sun, 22 Aug 2010 00:30:33 +0200
Message-ID: <AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux-mmc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/9 Hanumath Prasad <hanumath.prasad@stericsson.com>:

> Add support for Dual Data Rate MMC cards as defined in the 4.4
> specification.

Hm is there some problem with this patch or has the processing
of it simply stalled? When I read the thread I cannot see Hanumaths
answers on the list but it looks mainly like the patch is OK and
there is some chit-chat.

Can it be picked up? Everyone is going to need DDR MMC
for their eMMCs soon-ish.

Hanumath can you resend your comments to the list since they
seem to be lost.

Yours,
Linus Walleij
