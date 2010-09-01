Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0IAXUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:20:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32942 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0IAXUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uH0EWPJue/DYJykvskPFF4lsggNT/9ULr6oPqUVaAFnnALX76sHNEH7JTTLUXBFh1N
         t61cwv+E3lLdtRhkEqZvCPAj5XX3A/BDNr4PNrfnN3VryUEfwTvntZwPLgiKkcIjKrqT
         DsO/br+ICSjNE7XvzmxRmI/tKWwY8gN+M6iBk=
Subject: Re: [PATCH] ARM: pxa3xx: fix build error when
 CONFIG_MTD_PARTITIONS is not defined
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1282813011-6187-2-git-send-email-mark.brown314@gmail.com>
References: <1282813011-6187-1-git-send-email-mark.brown314@gmail.com>
	 <1282813011-6187-2-git-send-email-mark.brown314@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 02:20:14 +0300
Message-ID: <1283383214.2209.63.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 04:56 -0400, Mark F. Brown wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  drivers/mtd/nand/pxa3xx_nand.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Pushed to l2-mtd-2.6 / for-2.6.36, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

