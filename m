Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161214Ab1FALfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:35:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787Ab1FALfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b6L8WYMCghAzCXw+cXjxTk+yVEGlsTlhF8CUUCYZs7woNptTKxoZJrOTGYxaaTavvQ
         kwobD5A9MdVviQdWcijjuhpAZ6L6l5BPkF2E8iSLVKR+DtsB38OWGKLFzzJCWR/1qGuH
         /3C80xglk10BOtw/DLH9k2b3I+7Ra/YvsBu00=
Subject: Re: [PATCH] mtd: OneNAND: OMAP2: Return proper error if
 regulator_get fails
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
In-Reply-To: <1306848053.13412.1.camel@phoenix>
References: <1306848053.13412.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 14:30:35 +0300
Message-ID: <1306927835.4405.107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 21:20 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mtd/onenand/omap2.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pushed to l2-mtd-2.6.git, thank you.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

