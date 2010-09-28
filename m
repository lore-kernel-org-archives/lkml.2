Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab0I1UrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:47:13 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53476 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0I1UrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:47:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TLd7haQIcqeEvcWiLY/o/sNt0hulrOt01tcyGpqKSFh8m1rBoMk2mXiKyVvsqRusfx
         E72OMblk6cR4lGzQUR1DH+9ewJNZWGcObrSGLMtE1zqdb00TuLrDcUNRMyaXeMT2CgNO
         SZ+xnqgLuXiNcAo/2wnVls7aNZrRky48xVzL4=
MIME-Version: 1.0
In-Reply-To: <F45880696056844FA6A73F415B568C69532DC2F97F@EXDCVYMBSTM006.EQ1STM.local>
References: <1284031772-3496-1-git-send-email-arun.murthy@stericsson.com>
	<F45880696056844FA6A73F415B568C69532D594BA2@EXDCVYMBSTM006.EQ1STM.local>
	<F45880696056844FA6A73F415B568C69532DC2F97F@EXDCVYMBSTM006.EQ1STM.local>
Date: Tue, 28 Sep 2010 22:47:10 +0200
Message-ID: <AANLkTikhcWUGKd0i0ZMhMgNkERp5iSX99-21-+QS_EmX@mail.gmail.com>
Subject: Re: [PATCH] backlight: add low threshold to pwm backlight
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Arun MURTHY <arun.murthy@stericsson.com>, akpm@linux-foundation.org
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux@simtec.co.uk" <linux@simtec.co.uk>,
        "ben@simtec.co.uk" <ben@simtec.co.uk>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/28 Arun MURTHY <arun.murthy@stericsson.com>:

> If there are no comments, can you please pick this patch?

Hm, no Sign-offs or mails to be seen from Purdie since
May or June... :-(

Andrew would you mind queuing this one too in his absence?

We have some other backlight related stuff making rounds at
the moment and when I just search the archive for "purdie" there
seems to be a pile of stuff pending for Leds/Backlight actually.

Yours,
Linus Walleij
