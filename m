Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab1DAO6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:58:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53519 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab1DAO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y/MAWktK7YTXrvpi+/RHTSH57OqVKOzYqzvzkJtXBm+yulf6VcDA6ewl6KZD701YCW
         S3+YSGBsNikHnhckSAwAqBTX209/DhltabH8hxPHOJn/BqlP4GzbcGipocJQFe5lTZES
         pu7JOa94hxf7LRJ1y/oI1AgQIrWPuAQ/OqjQQ=
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D948D52.4040708@grupopie.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
	 <4D948D52.4040708@grupopie.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 17:56:16 +0300
Message-ID: <1301669776.2789.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 15:18 +0100, Paulo Marques wrote:
> Artem Bityutskiy wrote:
> > [...]
> > I personally think KALLSYMS_ALL should be just merged with KALLSYMS and
> > disappear - we should have only one option. CONFIG_KALLSYMS_EXTRA_PASS should
> > die as well.
> 
> That sounds a little too extreme...
> 
> KALLSYMS is useful for most kernels, since it provides nice readable
> stack dumps for panics and BUG's.
> 
> KALLSYMS_ALL adds a lot of extra symbols that can be useful mostly to
> development kernels and shouldn't be used to add unnecessary bloat to
> user kernels.

Well, ok, I've measured how much is this "a lot". On an embedded arm
platform this makes the kernel only 1.5% larger.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

