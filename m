Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1AJWBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:01:10 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48704 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1AJWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ALi8M/yUvBg6DWe+hVH5vx2fhRxK21buGwGsGMDO56mFJ6BsJSYyI6ui1gQBgRf3Cw
         hk1XIiOVBq8GuxsQowHFT7lRTemRVku4HDxOCR3eZQd0pBKAQt3XCLyloEJizNvMaxly
         4FcX96VLwb/h3aE4rkaqBcBJZ2XREoABpEQHw=
MIME-Version: 1.0
In-Reply-To: <cover.1294588491.git.tardyp@gmail.com>
References: <cover.1294588491.git.tardyp@gmail.com>
Date: Mon, 10 Jan 2011 23:01:04 +0100
X-Google-Sender-Auth: ajkWU--PzbP0Gb4Fvq-nnXaBJkA
Message-ID: <AANLkTim8pzrnvXh6ih+H-s4qF52FuJyeS21Csve+HAS1@mail.gmail.com>
Subject: Re: [PATCH 0/3] mmc: add quirks.c file and CLK_GATING users
From: Linus Walleij <linus.walleij@stericsson.com>
To: Pierre Tardy <tardyp@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/9 Pierre Tardy <tardyp@gmail.com>:

> this is a followup patchset of discussion that happen before on linux-mmc mailing list
> We add a mmc/core/quirk.c file holding list of quirks per devices or more generic quirks
> e.g. all sdio devices have this quirk.

I like this approach.
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
