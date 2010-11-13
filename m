Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0KMLTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:19:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab0KMLTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:19:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aapMUJ+W5ffFc/7oikDycybamPKpHGHWz7iZGUjugO3ocpvafeIy79e8y1P7vnQgMM
         ntO56KLomsb6OYAj35YfVj7fp5xgoGVfCuSrcHrdlPeUqSZie/+CUWlgjfa2GV8lbpnJ
         QYBI8npl3e2b13sfcUK676FCYH5RScczg+dV8=
Subject: Re: [PATCH 16/49] drivers/mtd: Use vzalloc
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <61af073f284d2169834120889a641cd11c370643.1288925424.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <61af073f284d2169834120889a641cd11c370643.1288925424.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 13:19:25 +0200
Message-ID: <1289647165.2218.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 20:07 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mtd/nand/nandsim.c |    3 +--
>  drivers/mtd/ubi/vtbl.c     |    6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

