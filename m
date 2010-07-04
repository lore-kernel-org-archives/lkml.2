Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab0GDU1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 16:27:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63010 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0GDU1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 16:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QdnDxkYDWWJoGZgVHo/Z7FzGotWV1St9jqbHn4aQa6ofLDrgmv0thIfGrdbe3ztNUF
         UZoH7KaFoblnHym6c/tdMHcSacfvaX1CjNYw4XH8NX5FcBl7jP57ziDBDrPOlMu3Vpqj
         fxe2GfADDL4l6woc4bMLPpWvA/KXpXquhappM=
MIME-Version: 1.0
In-Reply-To: <20100704103310.368dee05@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
	<1278193640-24223-3-git-send-email-arnd@arndb.de>
	<20100704080146.GA31828@merkur.ravnborg.org>
	<20100704103310.368dee05@infradead.org>
Date: Sun, 4 Jul 2010 22:27:11 +0200
X-Google-Sender-Auth: bvP3Rzr3NCN7NeUl0hjEAZS6bGQ
Message-ID: <AANLkTinduxuj8412d7eGK1qZGNHrIzCFOOrwXO5zBr5W@mail.gmail.com>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>,
       Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 4, 2010 at 19:33, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 4 Jul 2010 10:01:46 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
>> Lot's of other places could benefit from improved goto error handling.
>> The driver maintainers should do this (if there is a maintainer).
>> I stopped with the small replacement patches.
>
> it's the floppy driver for amigas
> not sure if any of those are still alive at all running linux.....

Sure there are. Whether the floppy drives in them are still actively used is
another question. SSH and NFS over Ethernet are much more convenient ;-)

Last time I tried (hmm, this or previous century?), my floppy drive had problems
reading the floppy, probably my drive is dying. Oh well...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
