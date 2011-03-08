Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1CHLDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:03:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43771 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1CHLDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z+LsbFBFj/5m8TnEPSbxOQCn97lGalYPzWwL7RQVXgyjCVIoAIU8Cb5UYfkdFZRd8z
         m5xjrtiKfJzy00R+a2M6KEGSSQQQH3bfGcB2ptXshU61BtxH+4gW4FS97GG0Q/vPjYYQ
         +plnW3v6598WeWVE8JZXpA0kl7343xGK28fxE=
Subject: Re: [PATCH 2/3] mtd: add "platform:" prefix for platform modalias
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jian Zhang <jzhang@ti.com>,
        Vimal Singh <vimalsingh@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
In-Reply-To: <1299467064.3879.3.camel@mola>
References: <1299466949.3879.0.camel@mola>  <1299467064.3879.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 13:01:48 +0200
Message-ID: <1299582108.2754.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 11:04 +0800, Axel Lin wrote:
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
> with "platform:"), the platform modalias is prefixed with "platform:".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Jian Zhang <jzhang@ti.com>
> Cc: Vimal Singh <vimalsingh@ti.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

