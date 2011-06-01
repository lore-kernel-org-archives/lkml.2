Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162753Ab1FAIk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:40:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43319 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162843Ab1FAIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l5pJVNeOwXNhz3FJPcnMjuNQyaXpugD4kH26V0y+vvLfpPJfA/043ZB6unQx9Q/6Nl
         glH/A7c7J41PRlMnmmUgmWPERpISd7RTg3i7tvEd6LfbbsSo6YNHOzOaj9vSjGfPBUyT
         LXrOKRWi4BkdKYGOKtG6F8igIGPKcdvQPyOdo=
Subject: Re: [TRIVIAL PATCH next 09/15] mtd: Convert vmalloc/memset to
 vzalloc
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Jiri Kosina <trivial@kernel.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <adc50014679048de28c7d536f1686cd945fc40f6.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
	 <adc50014679048de28c7d536f1686cd945fc40f6.1306603968.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 11:20:24 +0300
Message-ID: <1306916424.4405.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 10:36 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mtd/mtdswap.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

