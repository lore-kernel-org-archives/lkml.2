Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1DNMTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:19:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64450 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1DNMTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QcH/hyOk5EAxYIL3fryXvYuROM4Qqbm2YtbuCc1VXnpj4cdH7RxU5Uzx0XBHaLOLg3
         Bw3n90UBVSKu0xTVclWO7Hg3YthGmpt+d+1lKRolUu6xyi+NVJAfsJKdXQ2uluEZaxbt
         IEdkvGMnynRbBPVuPzotvxWEYlOw9ksVIWHp0=
Subject: Re: [PATCH 1/2] nand: Fix S3C NAND clock stop
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jiri Pinkava <jiri.pinkava@vscht.cz>
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
In-Reply-To: <1302688771-17252-1-git-send-email-jiri.pinkava@vscht.cz>
References: <1302665784.14691.5.camel@koala>
	 <1302688771-17252-1-git-send-email-jiri.pinkava@vscht.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 15:16:56 +0300
Message-ID: <1302783416.2796.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 11:59 +0200, Jiri Pinkava wrote:
> Current implementation of s3c2410_nand_select_chip call
> clk_disable every time when chip = -1 (de-select). This happend
> multiple times even if chip was already de-selected. This causes
> disabling clock even if they are already disabled and due to
> nature of clock subsytem implementation this causes nand clock
> to be disabled and newer enabled again.
> 
> Signed-off-by: Jiri Pinkava <jiri.pinkava@vscht.cz>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

