Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0CWHp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 03:45:28 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:45805 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0CWHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 03:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ushxYPwT1ycRlviPRtJg9Lg8CPFF/odVUkZxOFLnagPDhxZbVgzfR2ojQzqx6bKXoG
         OaZIrITFvM2rvIh4pnYdu7tAwotE/7CAmR2XwnubUZxhMf05P0Z2QwLDdmoOZSbZ4AXS
         lAN/f7kFroyRxOKM2PKE+pZwcAM4JooAfdbII=
MIME-Version: 1.0
In-Reply-To: <1268473347-29921-1-git-send-email-linus.walleij@stericsson.com>
References: <1268473347-29921-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 23 Mar 2010 08:45:26 +0100
Message-ID: <63386a3d1003230045h4772bea0v2259ed47340f3f78@mail.gmail.com>
Subject: Re: [PATCH 1/2] DMAENGINE: Support for ST-Ericssons DMA40 block
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/13 Linus Walleij <linus.walleij@stericsson.com>:

> This is a straightforward driver for the ST-Ericsson DMA40 DMA
> controller found in U8500, implemented akin to the existing
> COH 901 318 driver.

Have you had some time to look at this Dan?
(Just naggin'...)

Linus
