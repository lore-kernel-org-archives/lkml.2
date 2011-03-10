Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1CJNZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:25:54 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34736 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1CJNZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S7sCzp07Li817xyl4G6KBO0EJKKaWBnGVhpTtic3BAceaeNJl3W1t5rK6Ws20ipn1o
         wA/sX6ZcY8JzHPBOB0KCmlA/HN0aFoTdMEXNZr8gRhi24ecnGs28e9oluOGBg4nERgA/
         wt75hzMi9x9F78JqvvjcPbsPtz1AE3/ttf4To=
Subject: Re: [PATCH] cfi: add support for AMIC flashes (e.g. A29L160AT)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Steffen Sledz <sledz@dresearch.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1299744312-6291-1-git-send-email-sledz@dresearch.de>
References: <1299744312-6291-1-git-send-email-sledz@dresearch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 15:24:21 +0200
Message-ID: <1299763461.6676.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 09:05 +0100, Steffen Sledz wrote:
> Signed-off-by: Steffen Sledz <sledz@dresearch.de>
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c |    1 +
>  include/linux/mtd/cfi.h             |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)

Pushed to l2-mtd-2.6.git tree, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

