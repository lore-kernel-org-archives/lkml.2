Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0LSUye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 15:54:34 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52589 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0LSUyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 15:54:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UK1L+xvmhS/DbWrP8Qt30GT6u/zDJ4cCvbhjLoMDkRdQp+PwMKmbdx5tvrDF4wX0wc
         vyAfY9SdqahcSQJcPI6VOX2GceYdaVQhRc4fCyid3WbNLhlt/KaF0Sml7F9XdN0FBttV
         bYe5TtIoVQM9+J0cblXK3UqFgs6h6GlXwLJyo=
MIME-Version: 1.0
In-Reply-To: <1291388753-14662-6-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
	<1291388753-14662-6-git-send-email-sundar.iyer@stericsson.com>
Date: Sun, 19 Dec 2010 21:54:32 +0100
X-Google-Sender-Auth: RlV8ow97W6bX-g4dxhAdfeZzi8I
Message-ID: <AANLkTikak9eRJVVjWszxMAx+hnd2GZpeMrevL1FnsA0K@mail.gmail.com>
Subject: Re: [PATCH 05/20] mach-ux500: add STMPE1601 platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        sameo@linux.intel.com, ben-linux@fluff.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I managed to rebase and push patch this patch too.

Now I get input characters from my STMPE1601 keypad on the
STUIB :-)

Yours,
Linus Walleij
