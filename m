Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab0EKFt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:49:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0EKFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QkwUrhUdxEoYpsGCScIhQqQJlKH2dOsF8JkWkqQ5uyGBbhmqnDJ8onnMJe1YNEtYGx
         nCWGZ5xK1XpRPJCgCb21hFwwxI5gySS5j9CJ0WIaVGYnB3qPGNd9cqy9PKWht9UWYcBs
         /vi23ARKRgYVQeLUqT+O4O6yy2jDBzyDkvon4=
MIME-Version: 1.0
In-Reply-To: <20100510223424.GC3288@sortiz.org>
References: <1272731191-30233-1-git-send-email-linus.walleij@stericsson.com>
	 <20100510223424.GC3288@sortiz.org>
Date: Tue, 11 May 2010 07:49:54 +0200
Message-ID: <AANLkTinw0HczDytbRUNOvozLHZotCrhs1xKQQ7BdhMTh@mail.gmail.com>
Subject: Re: [PATCH 3/4] MFD: AB3550 core driver v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com,
       Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/11 Samuel Ortiz <sameo@linux.intel.com>:

> Hi Linus,
> I applied this patch with some additions:
> - It now depends on GENERIC_HARDIRQS
> - It no longer is tristate but bool, as the genirq API is not exported to
> modules.
> - I added an ifdef ARM around your set_irq_flags() call to have this driver
> build in other archs than ARM.

Thanks a lot for fixing the final things for us and including the
patch!

Yours,
Linus Walleij
