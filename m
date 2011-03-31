Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab1CaOBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:01:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45233 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab1CaOBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Va2zN7TEHNiLtvk20RWbPxAHE2CTw33/Gtlj3Y3DAXnIVqpoiYSS/jcF2HISD1iScn
         kQVbmrC7v85ehLs0KOR9Xf/ErlvTf47+I695lYGra36Jt9nEwYzGi0VwUkDU9aMJULoZ
         h/E+8NyNLhGqNTMK+cJPivI9V9TJ0FTji0X8A=
Subject: Re: [PATCH] jffs2: unused variables cleanup in jffs2_lookup and
 jffs2_readdir
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110322121102.GC5086@swordfish.minsk.epam.com>
References: <20110322121102.GC5086@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 16:58:28 +0300
Message-ID: <1301579908.2828.83.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 14:11 +0200, Sergey Senozhatsky wrote:
> jffs2: cleanup unused jffs2_sb_info *c variable and JFFS2_SB_INFO call from jffs2_lookup 
> and jffs2_readdir
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

I amended the commit message and pushed this to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

