Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab1DNMUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:20:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44961 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab1DNMUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rgVHcdgI7wIhOXuMURhiMJQaGKNMA30H8C4/JgulsXAUL4/Ft0mogsGQUjcZ2ZNVv/
         wdvxk1EOCEo/7PTCPUzowIv6i5cmjNMb7ebH3sH1pLU4O2L42X+wrVwfOHZfq6xcjdwS
         6eH2WfqCkovz0MfkX34iPT0o1xG5sZ+Ezc7i0=
Subject: Re: [PATCH 2/2] nand: Remove unnecessary variable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jiri Pinkava <jiri.pinkava@vscht.cz>
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
In-Reply-To: <1302688771-17252-2-git-send-email-jiri.pinkava@vscht.cz>
References: <1302665784.14691.5.camel@koala>
	 <1302688771-17252-1-git-send-email-jiri.pinkava@vscht.cz>
	 <1302688771-17252-2-git-send-email-jiri.pinkava@vscht.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 15:17:23 +0300
Message-ID: <1302783443.2796.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 11:59 +0200, Jiri Pinkava wrote:
> Signed-off-by: Jiri Pinkava <jiri.pinkava@vscht.cz>
> ---
>  drivers/mtd/nand/s3c2410.c |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)

Let's drop this, sorry, I gave you wrong advise.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

