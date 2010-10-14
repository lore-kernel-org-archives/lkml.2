Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0JNK0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:26:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39828 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab0JNK0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=v92li+KoItjjcmbIyG9qjpcfYRKwD/khDAMQjRaO//PsUxCma5UjKVHSeKTgG/ReUx
         xxn60cb4dUmmAacAQ7y6g0z+gbL2muWBoJI7KWa5v70Zul40uUo0sHk5gGURwva9HATW
         8Bg+mFtovgvAULN/xQk24tnIwMSTtoqjoC4fQ=
MIME-Version: 1.0
In-Reply-To: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
Date: Thu, 14 Oct 2010 12:26:45 +0200
Message-ID: <AANLkTin1RjhDZp6w-jumRnZ1-Hx3zio7SrZtZqummok2@mail.gmail.com>
Subject: Re: mmotm 2010-10-13-17-13 uploaded
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/14  <akpm@linux-foundation.org>:
> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to

linux-next.patch breaks things

  GEN     /home/test/linux-2.6-obj/Makefile
  HOSTCC  scripts/kconfig/zconf.tab.o
In file included from scripts/kconfig/zconf.tab.c:2462:0:
scripts/kconfig/lex.zconf.c:2425:7: error: conflicting types for 'zconf_curname'
/home/test/linux-2.6-mm/scripts/kconfig/lkc.h:79:13: note: previous
declaration of 'zconf_curname' was here
scripts/kconfig/lex.zconf.c: In function 'zconf_curname':
scripts/kconfig/lex.zconf.c:2427:2: warning: return discards
qualifiers from pointer target type
make[3]: *** [scripts/kconfig/zconf.tab.o] Error 1
make[2]: *** [silentoldconfig] Error 2
make[1]: *** No rule to make target `include/config/auto.conf', needed
by `include/config/kernel.release'.  Stop.
make: *** [sub-make] Error 2


-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
