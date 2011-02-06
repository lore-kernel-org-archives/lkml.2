Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1BFPJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:09:22 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62279 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab1BFPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AEaGxPAMR8KjJYq2QUOPnPdZ++pDQCCGQqsCEx1HGLISE9dcLjVBPKCbXJpI1MvSOL
         OvU6NdMKjm2Bs2maDOpa+CB7hqnBf0MYLp8y9ekJSHsdg9Zu4cq1yoaKEWrnkKy2+gKA
         zf3etYTg6Z5wbs5DFSCL/Ub4ZsHO9mQmXZruE=
Subject: Re: [PATCH] drivers/mtd/maps/ts5500_flash.c: avoid calling
 map_destroy on NULL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1296666816-21610-1-git-send-email-julia@diku.dk>
References: <1296666816-21610-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 17:08:24 +0200
Message-ID: <1297004904.4460.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 18:13 +0100, Julia Lawall wrote:
> map_destroy dereferences its argument.  The call is furthermore only
> reachable when this argument is NULL.  Thus the call is dropped.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

