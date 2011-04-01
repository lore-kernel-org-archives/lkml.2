Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab1DANje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:39:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44849 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab1DANjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p8gFrWxxP8RyYJ7vRMuUuHqceCTy1kgteR8Cp0AZHVms0fS0LMt8B8qP3eRNVgFwIr
         iuKwpXMygy4/FWDeCYBRK75gSK2o9pmi9eeNPoWxzu05LMpKZTGqNJ7lkHL+t+TsmTOB
         EoPT9wOYmtqP5utnqq8ppqaBBFkmBhdyaS3Oo=
Subject: Re: [PATCH 1/3 v2] MTD: atmel_nand: modify test case for using DMA
 operations
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hong.xu@atmel.com
In-Reply-To: <1301668844-4500-1-git-send-email-nicolas.ferre@atmel.com>
References: <1301662188.2789.57.camel@localhost>
	 <1301668844-4500-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 16:36:42 +0300
Message-ID: <1301665002.2789.75.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 16:40 +0200, Nicolas Ferre wrote:
> We have better performances not using DMA for oob operations.
> Modify size test so that it is using DMA for size greater than oobsize.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Pushed to l2-mtd-2.6.git, thank you!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

