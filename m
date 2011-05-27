Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1E0Fdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:33:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64275 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1E0Fdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=paS33mrlKwAWz3zAtiK+S5WDlQmyMaIl/8nHeAunpe0lWngXPto43z0QG2To56sZzd
         LB2Sxu6f5/oLFNqyAJd1+SuAQnmOKLjdWCkMnl1Njh/mMyC8y2XfZ1EkzVgkRZvFkCnM
         O3KpHzrTZ+J+3Z/CTURkVypVv/dfyzPM3HeI8=
MIME-Version: 1.0
Date: Fri, 27 May 2011 07:33:49 +0200
X-Google-Sender-Auth: YSp57HXkZNGJOyMixw7E44E6w20
Message-ID: <BANLkTi=3zsM-NUsFy-fe7sdoryTyqr+o7Q@mail.gmail.com>
Subject: [-next] several files need to include <linux/bitops.h>?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kisskb.ellerman.id.au/kisskb/buildresult/4194288/

mm/page_alloc.c:3311: error: implicit declaration of function 'ffz'
make[2]: *** [mm/page_alloc.o] Error 1
make[1]: *** [mm] Error 2
block/blk-flush.c:111: error: implicit declaration of function 'ffz'
make[2]: *** [block/blk-flush.o] Error 1
make[1]: *** [block] Error 2
include/linux/inetdevice.h:254: error: implicit declaration of function 'ffz'
make[3]: *** [net/ipv4/route.o] Error 1
kernel/signal.c:182: error: implicit declaration of function 'ffz'
make[2]: *** [net/ipv4] Error 2
make[2]: *** [kernel/signal.o] Error 1
make[1]: *** [kernel] Error 2
include/linux/inetdevice.h:254: error: implicit declaration of function 'ffz'
make[3]: *** [net/core/dev.o] Error 1
drivers/md/raid0.c:430: error: implicit declaration of function 'ffz'
make[3]: *** [drivers/md/raid0.o] Error 1
make[2]: *** [drivers/md] Error 2
drivers/ide/ide-probe.c:1216: error: implicit declaration of function 'ffz'
make[3]: *** [drivers/ide/ide-probe.o] Error 1
crypto/lrw.c:125: error: implicit declaration of function 'ffz'
make[2]: *** [crypto/lrw.o] Error 1
drivers/input/keyboard/hilkbd.c:243: error: implicit declaration of
function 'ffz'
make[2]: *** [net/core] Error 2
make[1]: *** [net] Error 2
make[2]: *** [drivers/ide] Error 2
lib/find_next_bit.c:226: error: implicit declaration of function 'ffz'
make[2]: *** [lib/find_next_bit.o] Error 1
make[4]: *** [drivers/input/keyboard/hilkbd.o] Error 1
make[3]: *** [drivers/input/keyboard] Error 2
make[1]: *** [crypto] Error 2
make[2]: *** [drivers/input] Error 2
make[1]: *** [drivers] Error 2
make[1]: *** [lib] Error 2
fs/minix/minix.h:135: error: implicit declaration of function 'ffz'
fs/minix/minix.h:135: error: implicit declaration of function 'ffz'
make[3]: *** [fs/minix/itree_v1.o] Error 1
fs/minix/minix.h:135: error: implicit declaration of function 'ffz'
make[3]: *** [fs/minix/itree_v2.o] Error 1
make[3]: *** [fs/minix/bitmap.o] Error 1
fs/minix/minix.h:135: error: implicit declaration of function 'ffz'
make[3]: *** [fs/minix/namei.o] Error 1
make[2]: *** [fs/minix] Error 2
make[1]: *** [fs] Error 2
make: *** [sub-make] Error 2

-- 
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
