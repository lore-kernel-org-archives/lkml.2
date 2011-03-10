Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1CJNPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:15:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39571 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1CJNPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:15:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CKgYfgWcxbWpoh5gxUCuOPgBCHfmxInMneGw26Q0rWvoBoK8J8vYrDkFOBRWvGosfE
         9FDTbGo9nhcndnQCtOcxwjSFnIHODeLMuKlFN3nlZfOHiZIdWyqDhgYcQwR1O5wY+mIO
         B+MIRBRE+080WqUfssfEErF8UHd8ORUYA55sI=
Subject: Re: [PATCH/RFC v3 1/3] Shared BCH ECC library
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ivan Djelic <ivan.djelic@parrot.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4c9c56a72dda5d22f91f252f103e4ec760c913c1.1299691382.git.ivan.djelic@parrot.com>
References: <4c9c56a72dda5d22f91f252f103e4ec760c913c1.1299691382.git.ivan.djelic@parrot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 15:13:46 +0200
Message-ID: <1299762826.6676.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 18:50 +0100, Ivan Djelic wrote:
> Hello,
> 
> The first patch of this series contains a new generic BCH ECC library.
> 
> This library can be used to provide software BCH correction on NAND devices
> (see 2nd and 3rd patch), as well as error correction for hybrid hardware BCH
> engines.
> 
> This version v3
> - improves Kconfig help description as suggested by Artem Bityutskiy
> - documents the public domain origin of a parity computation code snippet
> 
> Could you please review and comment ?
> Thanks,

I've put these patches to my l2-mtd-2.6 tree, let's see if dwmw2 merges
them. I doubt there are many people who'd wish to really review it, but
indeed the code looks good.

There are a couple of checkpatch.pl complaints for the 3rd patch, not
very important though. Also, I think nowadays we do not put file name in
the comments like you did:

+/*
+ * include/linux/bch.h
+ *

But again, not big deal. But it is better to address these tiny things,
anyway. If you re-send v4 - I'll put it to my tree instead of v3.

Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

