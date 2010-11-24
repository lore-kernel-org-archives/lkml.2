Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0KXOaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:30:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51946 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0KXOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:30:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wTwJc8Hcwsm3TqxNrub02Son6XJa+Fa6LETb1qmETF80e9dl80wwXpk9IRLXbG5H5Z
         p+0P/0faPL7CpYZIQoYkMMqUaCY9O041I5Vqo17TlhgJ8ZXVFhFtNxOmaiFj48rMRNc8
         K3zqvPK9NzTFT/zjXZZNJPvUlPKTEEmTa6tjs=
Subject: Re: [PATCH] generic-ipi: add lock context annotations
From: Namhyung Kim <namhyung@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101124054305.GP1522@bicker>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
	 <1290430003.2072.101.camel@laptop> <1290482390.1857.26.camel@leonhard>
	 <4CEB8034.80400@fusionio.com> <20101123094016.GC8882@bicker>
	 <1290576280.1690.13.camel@leonhard>  <20101124054305.GP1522@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 23:29:56 +0900
Message-ID: <1290608996.1675.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-24 (수), 08:43 +0300, Dan Carpenter:
> On Wed, Nov 24, 2010 at 02:24:40PM +0900, Namhyung Kim wrote:
> > 2010-11-23 (화), 12:40 +0300, Dan Carpenter: 
> > > On Tue, Nov 23, 2010 at 09:49:56AM +0100, Jens Axboe wrote:
> > 
> > I tried to annotate declations in include/linux/smp.h but it didn't work
> > well. Maybe that's what we need to fix the sparse?
> > 
> 
> It worked for me earlier when I tested it.  Just add the exact same
> annotations that you added to the .c file.
> 
> regards,
> dan carpenter
> 

OK. You mean annotating both .c and .h, right? Will send v2 soon.

Thanks.

-- 
Regards,
Namhyung Kim


