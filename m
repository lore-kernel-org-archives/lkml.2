Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab1FAKXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:23:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62145 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab1FAKXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RDtByepgSCqG3MSUZN2ihMoywKTxYGzEXz9tUFf/2RrYdWMmOSODKcpwKGZr8KMbry
         7NQXhrz6tTvxmaLeEfYbk3B5veQA52+xTKpNEYe7AxDY53wNpfhOEny3ZZT9vdsVan5T
         s+2CnN3+hbVhL2LD0N8NPKfhoTFeraZU+7kb8=
Subject: Re: [PATCH 0/3] fix-up free space earlier in mount_ubifs()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
In-Reply-To: <cover.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 13:19:25 +0300
Message-ID: <1306923565.4405.96.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 14:56 -0400, Ben Gardiner wrote:
> In testing Mattew Creech's free-space-fixup flag series I found that was unable
> to boot a da850evm which had flashed to it's NAND a ubinized image containing a
> UBIFS that has the free-space-fixup flag set.
> 
> The cause of the problem was found to be the call to ubifs_write_master() from
> mount_ubifs() as is evidenced the backtrace produced by the assertion
> introduced in the first patch of this series; where the assertion introduced is
> that c->space_fixup is false when ubifs_write_node() is called.

So the fixes are now in the ubifs tree. You can see them in the
linux-next banch's tip or in the master branch under a pile of other
changes. The point is that linux-next currently contains what I want to
merge to linux-3.0 and master branch contains the same plus a pile of
things for linux-3.1.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

