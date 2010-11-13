Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0KMLTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:19:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab0KMLTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:19:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NbOJLPbh87d0xaaCDDgHMeOJcuxu+KEmDzlgFlBRg2O7y/w0or5F0S1hyNOi7Q8rfG
         YtGDuR5czVQC5BrZKq3hX7hyX3s3GJB/uQERB8z+9/hLSi31RnM8nz04ZAVSyPvatlCE
         S/6CRias1EbiN3heDRZUhEjOnZ/fxAmituWso=
Subject: Re: [PATCH 38/49] fs/jffs2: Use vzalloc
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1c6caf522ea9088919a89c8c23c54436c7020cdb.1288925425.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <1c6caf522ea9088919a89c8c23c54436c7020cdb.1288925425.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 13:19:34 +0200
Message-ID: <1289647174.2218.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 20:08 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/jffs2/build.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

