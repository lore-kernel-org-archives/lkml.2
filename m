Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0JUKkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:40:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34008 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0JUKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y3SLF2mCCIWcbmb7puADwAB2A4e8f3gE51uYJxkyh5dXgjWuoJp1nF7b4AeKo1lCjH
         a4d/5L0n69J7HgeltKOYiYS79imkALt+8CDaCb98ictWKeEVCEcpebF/0jborbZ4QipN
         wrb67FOD3XTAKvVc1WuAGnEh8fWKTFOLZl6BQ=
Subject: Re: [PATCH] drivers/mtd/devices/phram.c: Use KBUILD_MODNAME
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287596362.1813.205.camel@Joe-Laptop>
References: <1287596362.1813.205.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 13:37:32 +0300
Message-ID: <1287657452.2932.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 10:39 -0700, Joe Perches wrote:
> Use the more standard #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> No change in output strings.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

