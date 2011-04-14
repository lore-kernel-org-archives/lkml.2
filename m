Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1DNMLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:11:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64269 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1DNML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=StljXorwc4D6RlBQ74PHY0OFidJjE+9xAXCm78pHNm6kIJIVtGTfaRq6jIFwTJ1j9p
         AwRZLv8Fcjb+SRJ5IhGJ5k7vPGlY2M7n6CsxSQmhsRO3wfDPxGmgMTdHLI1ikxr5b42V
         x1mIL4SM7+xyU9N0QpOywW7xI1YPFidynT7TU=
Subject: Re: [PATCH 1/2] MTD: s3c2410_nand: Add option to disable hw ECC at
 runtime
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Holger Freyther <zecke@openmoko.org>
In-Reply-To: <1302637672-25339-1-git-send-email-lars@metafoo.de>
References: <1302637672-25339-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 15:08:31 +0300
Message-ID: <1302782911.2796.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 21:47 +0200, Lars-Peter Clausen wrote:
> From: Holger Freyther <zecke@openmoko.org>
> 
> This patch adds a flag to the s3c2410_nand platform data, which configures
> whether hardware ECC is used.
> 
> Currently it is only possible to decide whether hw ECC should be used or not at
> compile time through a config option. But if you want to build a kernel which
> runs on multiple devices you might have a configuration where some devices
> require hw ECC and some devices which want software ECC.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Extending platform data is kind of vetoed in arm tree, I do not think
the MTD tree can take these changes.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

