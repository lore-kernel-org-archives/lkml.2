Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab1ESRiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:38:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59903 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933649Ab1ESRiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=n8Zze6KAWsmzu91ENSOdmKuQAYlt41dlYCfRNZvlCflPsMGCdVIx3oYifaTNYMOLFq
         /p0Z+5uRXmlqSVcHgbHRsaPBdehHjUuIOCYlITohCENwaYyI+S7i9a5FJy+AInyy3mMZ
         1cmE5eNQAE3jTY2jYTE7A3saDpaE1aw/hzQhI=
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF0498A47BF9@HQMAIL01.nvidia.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
	<74CDBE0F657A3D45AFBB94109FB122FF0498A478E6@HQMAIL01.nvidia.com>
	<BANLkTimMHjUFN8NqAxoF5h_eXgmJP+znSg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF0498A47BF9@HQMAIL01.nvidia.com>
Date: Thu, 19 May 2011 19:38:22 +0200
X-Google-Sender-Auth: Lg0s8BXf5bX0LQbtOVGnHGuPwSQ
Message-ID: <BANLkTikeY5QVpEa8uXckcFGvUf7Lg1PviA@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pinmux subsystem v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19 Stephen Warren <swarren@nvidia.com>:

> Still, if I was writing the patches, and I agreed with the above change,
> I think I'd want to put it into the first patchset (or at least before
> other people started implementing their pinmux drivers on top of the code)
> since it'd avoid everyone else (or me) having to refactor all their
> drivers almost immediately after writing them, plus it looks like a very
> simple change to the current pinmux patchset.

You're right and Sascha said the same thing, so I will includ it
in v3. I expect an Acked-by: in return ;-)

Yours,
Linus Walleij
