Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1DDHOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:14:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48425 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1DDHOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZAukPNhXGAYMUgVFzZyPrRiSmpG3ADu68SLxGl12+3+eUgt4OAmlIyAYD0Tq76zVN8
         /TiWxGrRSODkXqBD8Ku4PUhw3Lh3bRSQ/TZFVUdLLmmlipQHVjznsPhi9YkLgu+zCGlN
         dXjDD/lr9dEn0zJauoo5D/A6DZNPT72PXkKwg=
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D95F54D.8020802@grupopie.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
	 <4D948D52.4040708@grupopie.com>  <1301669776.2789.92.camel@localhost>
	 <1301670104.2789.94.camel@localhost>  <4D95F092.4080604@grupopie.com>
	 <1301672549.2789.107.camel@localhost>  <4D95F54D.8020802@grupopie.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 10:12:09 +0300
Message-ID: <1301901129.2760.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 16:54 +0100, Paulo Marques wrote:
> Artem Bityutskiy wrote:
> > On Fri, 2011-04-01 at 16:34 +0100, Paulo Marques wrote:
> >>[...]
> >> With an automatic makefile mechanism, the problem would go unnoticed and
> >> it just wouldn't be fixed, increasing the kernel compile time for
> >> everyone who hits the same troublesome configuration.
> > 
> > Yes, the build system may print a message:
> > 
> > Your symbols table is screwed, this is a bug, report about it. As a
> > temporary workaround use "make KALLSYMS_EXTRA_PASS=1"
> > 
> > Or something like that.
> 
> Yes, I think that would work too, and it would even prevent the option
> from being on for no good reason.

I'll try to find some time and cook a patch.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

