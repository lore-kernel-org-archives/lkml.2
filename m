Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0KZP7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:59:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44055 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0KZP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IupHa13BlaxZvL75bd7tt96rB2Doy1cyDnabJUpXQse4/nmJ5ZNlhEA+V6sxY7vN2b
         Xu4lUNg1ocHFHuOLTGAHjSmg56tSMuQ7GTOWUvir0b9ye7pVASN04K3jRsI3xMlNxcPR
         y6wMxbX+nHGZB8xNR9nnSWHxhBR1t+oFSfvRc=
Subject: Re: [PATCH 07/14] drivers/mtd/maps: Use printf extension %pR for
 struct resource
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Jim Cromie <jim.cromie@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <5f4704a88f6e5bf55f19b4e6d8c7abce6ea20f71.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
	 <5f4704a88f6e5bf55f19b4e6d8c7abce6ea20f71.1289597644.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 17:59:14 +0200
Message-ID: <1290787154.2552.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 13:37 -0800, Joe Perches wrote:
> Using %pR standardizes the struct resource output.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mtd/maps/amd76xrom.c       |    7 ++-----
>  drivers/mtd/maps/ck804xrom.c       |    7 ++-----
>  drivers/mtd/maps/esb2rom.c         |    9 +++------
>  drivers/mtd/maps/ichxrom.c         |    9 +++------
>  drivers/mtd/maps/physmap_of.c      |    4 +---
>  drivers/mtd/maps/scx200_docflash.c |    5 ++---
>  6 files changed, 13 insertions(+), 28 deletions(-)

Pushed this patch and patch N8 to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

