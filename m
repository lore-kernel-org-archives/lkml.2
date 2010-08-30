Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0H3Kh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:37:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49720 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0H3Khz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=W0ySJYNctKqCWar6VZavwihsE7qQukkw1qcm5O0Jm6J01Ym3iPA9j3fOhzN/goChtE
         I6D9NF1f5vAGEPfe/z3Ei0aSZnWw5Y7pSFcVVdCA24SfZjhOC7H1Y4PRlivekIw5PDXN
         a15om641xFsoQPBynyJm35A7Fv6AdNiuwovaI=
Subject: Re: [PATCH] mtd/chips: cleanup Kconfig dependencies
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
        linux-mtd <linux-mtd@lists.infradead.org>
In-Reply-To: <201008191818.21506.hartleys@visionengravers.com>
References: <201008191818.21506.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 13:36:33 +0300
Message-ID: <1283164593.12995.47.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 18:18 -0700, H Hartley Sweeten wrote:
> Remove the MTD!=n dependency since that is handled by drivers/mtd/Kconfig.
> Simplify the dependency checks for mtd/chips by using if/endif blocks. Remove
> all default n since that is the Kconfig default.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>

Pushed to l2-mtd-2.6.git / master, thanks!

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

