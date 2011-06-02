Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1FBQZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:25:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58303 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1FBQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BUPDE3uFalYKtVMEkahkyLrDLLQXcbAV7M6HLXyaxYWMVxEdZmv4VVV3tm65Rcdu7s
         kYh9bMwoiFWaqZYxS2GtxpYxSThli9wl0Fqaq2ycfXj02NbH1g2cYv0lY61u/ysBjHQl
         +1G6rT+N23OJbxRoOwp4Y7TayAn+ifHszP9cc=
MIME-Version: 1.0
In-Reply-To: <20110602115045.41815756.sfr@canb.auug.org.au>
References: <20110602115045.41815756.sfr@canb.auug.org.au>
Date: Thu, 2 Jun 2011 18:25:06 +0200
X-Google-Sender-Auth: gal9mUB9xf4CYdxvt1IAAj5qLgM
Message-ID: <BANLkTikm=bBM=E5LtCxOg29U-nwniqx0WQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (ux500-core tree related)
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rickard Evertsson <rickard.evertsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Deepak Karda <deepak.karda@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/2 Stephen Rothwell <sfr@canb.auug.org.au>:

> After merging the final tree, next-20110601 build (arm u8500_defconfig)
> failed like this:

Oh crap, I thought that patch was independent but it wasn't. I'll
take it out.

Thanks for noticing this Stephen,
Linus Walleij
