Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1BOOYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:24:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52943 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1BOOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kDVpsJQqeMkrNHcy1AP7KA9Rh5StyowWvVxawRisuXqrx7bG4/j2cqi1ARbF8gajph
         6lt2uqa2X0ILzJwfbRdOxiuMXB24rF2dqWTjOqOkqJM1nocpF2nfTIy90QdEl/qNqk4u
         Jb/Gi1VU5mVvaJBX6NhY1repNPp1bEeGjRfEw=
MIME-Version: 1.0
In-Reply-To: <20110212084814.22218.92022.stgit@localhost6.localdomain6>
References: <20110212084814.22218.92022.stgit@localhost6.localdomain6>
Date: Tue, 15 Feb 2011 09:20:59 -0500
Message-ID: <AANLkTinf_GiHFd56jkF4dyfaOEGY58OxRp8ohbO3Qiox@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add entry for GPIO subsystem
From: Josh Boyer <jwboyer@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 3:48 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> I'll probably regret this....
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

You  might as well just do the below instead, given the number of
subsystems you maintain and areas of focus you have. ;)

josh

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 531c5cf..7773c8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2409,6 +2409,7 @@ F:        drivers/net/ehea/

 EMBEDDED LINUX
 M:     Paul Gortmaker <paul.gortmaker@windriver.com>
+M:     Grant Likely <grant.likely@secretlab.ca>
 M:     Matt Mackall <mpm@selenic.com>
 M:     David Woodhouse <dwmw2@infradead.org>
 L:     linux-embedded@vger.kernel.org
