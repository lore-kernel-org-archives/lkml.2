Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0HWHVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 03:21:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52540 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0HWHVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 03:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AQ6bL6pJYsTTHWUSAfEhfjQuWRLefx6eG8q5X83j8ZbQps1Kk+luTvKhVHfS/x22pN
         Lzupa0/W8xaQZdmrbrhOHulz8498WumISyrYlIoRV6azLwnIHBRig+vpFka8TO8lxP1Y
         WnJvimK9Usf4alNaBTkSpIm0MDk/wrsSBVSbE=
MIME-Version: 1.0
In-Reply-To: <m3pqxbsibq.fsf@pullcord.laptop.org>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
	<AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>
	<m3pqxbsibq.fsf@pullcord.laptop.org>
Date: Mon, 23 Aug 2010 09:21:47 +0200
Message-ID: <AANLkTi=w2Yr55DR8zrXam6EPueT0GYRHr2XWQqDZKpJ5@mail.gmail.com>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/22 Chris Ball <cjb@laptop.org>:

> I'd like to dedicate more time to mmc/.  Do you think it'd be useful
> for me to catch all the patches sent to linux-mmc@ into a public Git
> tree, and periodically report on what went upstream via akpm and
> what's still waiting?

That sounds very close to getting it participate in linux-next.

Which in turn would make it convenient for you to issue pull
requests to Linus (Torvalds) directly.

Which would make you the MMC subsystem maintainer...

So why not :-)

Yours,
Linus Walleij
