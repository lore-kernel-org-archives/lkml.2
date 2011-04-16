Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1DPOUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:20:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55998 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1DPOT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=adubuqbMUGtbLUnhbX2yDltqZkPCAaSt3RaVLtl2G9oj6R32IpAM1qLE2wbewbSwdO
         WlKGYJPEGkxLdHxDMRNcFhht/N8QwhC7WC0BbMADobI10UZirDgIM27bcy1FOwzvb8OD
         QsgqNcay7hJnIzUKzt+i3beb0Q4izuGLbMKEQ=
Subject: Re: [PATCH 2/2] mtd: msm_nand: Add initial msm nand driver support.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Murali Nalajala <mnalajal@codeaurora.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <4DA96890.2070207@codeaurora.org>
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
	 <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>
	 <1302861097.3220.12.camel@localhost>  <4DA85B24.50807@codeaurora.org>
	 <1302942029.2308.1.camel@koala>  <4DA96890.2070207@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Apr 2011 17:19:50 +0300
Message-ID: <1302963590.2308.9.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can i export this variable now?

I do not think so, we do not export random variables.

> What is your suggestion?

But I already did provide you suggestions - kill this global variable
completely. I provided the reasons:

1. It is error prone to hide functions behind something which looks like
a constant.
2. Multiple controllers with different base addresses wouldn't work -
your driver has to be able to at least theoretically handle multiple
controllers with different bases.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

