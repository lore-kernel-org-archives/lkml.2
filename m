Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab0LSTWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 14:22:18 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51004 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab0LSTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 14:22:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KWL+9OoG7HCIAicBTA5vBsgmDyWFEIKMtSr5MS5wRrFlD5dDb9uJfh2JWxG9SdjwxG
         D6rtc/sGINIvecVAFnWD7J16cAA/+9EbLk8S7K/q0VTgZKNnZkffof2K25chVM9JSL9M
         EapdorHsiJVCuDEUylV+BwdtXGV+uu4PUCUnY=
MIME-Version: 1.0
In-Reply-To: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
References: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
Date: Sun, 19 Dec 2010 20:22:16 +0100
X-Google-Sender-Auth: lW-gj-Yv-3a8gDFllj2AFt4Xqyg
Message-ID: <AANLkTimZfuNKvOAQMj46aC4Q4WjbRm0XqBHJBHtQa+fw@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] mfd/tc35892: allow to support multiple variants
From: Linus Walleij <linus.walleij@linaro.org>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/13 Sundar Iyer <sundar.iyer@stericsson.com>:

> The following patch series allows multiple variants of the Toshiba
> TC35892XBG port expander devices into the same mfd core driver.

Thanks Sundar, I've applied these to ux500-core for testing in -next.

I will try to see if your platform data refactorings from the previous
patch set applies cleanly on top of this (or if I can easily rebase
them).

Yours,
Linus Walleij
