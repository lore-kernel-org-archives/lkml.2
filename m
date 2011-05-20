Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355Ab1ETFlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:41:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65126 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935321Ab1ETFlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vBOWIr/Xew1T6vBeq5tHBIafGWvDqx6uHHiGa959c9Kzxg+xA4lTmaHhkGwbANx78L
         +ltCd7cJXLaU24hwfejnJGuLDf96FRThsF7H7yA74e2kZholjLbYiVlqNTcRZK6N8Gm9
         U+hQJroq2spSjahAjJrA1ctuDfKENzELYKD60=
Subject: Re: [PATCH 2/2] driver:mtd:fix the bad format in the mtdcore.c
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: dwmw2@infradead.org, akpm@linux-foundation.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305642979-7419-2-git-send-email-wanlong.gao@gmail.com>
References: <1305642979-7419-1-git-send-email-wanlong.gao@gmail.com>
	 <1305642979-7419-2-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 08:38:00 +0300
Message-ID: <1305869880.2630.88.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 22:36 +0800, Wanlong Gao wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Fix the bad format in the mtdcore.c.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  drivers/mtd/mtdcore.c |   34 +++++++++++++++++-----------------
>  1 files changed, 17 insertions(+), 17 deletions(-)

This patch does not apply to my l2 tree because proc-related functions
have been re-worked recently, see

http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/b930b5a0cee30792579a1893a732a485c1f1f0ba

Please, send a patch on top of l2-mtd-2.6.git:

git://git.infradead.org/users/dedekind/l2-mtd-2.6.git

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

