Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab2C3ISH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:18:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54734 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759577Ab2C3ISA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:18:00 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19dsytYwg5dZ67Sx6UE0StW493fvfku/G1qes7aaO
	yFBukQQG1kVSNg
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 1/2] um: Disintegrate asm/system.h
Date: Fri, 30 Mar 2012 10:17:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.13; KDE/4.8.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        dhowells@redhat.com
References: <1333041530-2998-1-git-send-email-richard@nod.at>
In-Reply-To: <1333041530-2998-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203301017.56559.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Richard Weinberger wrote at 19:18:49
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> CC: dhowells@redhat.com
> ---
works fine.
Now the situation is the same as before :/ :

...
  LD      init/built-in.o
  LD      .tmp_vmlinux1
/usr/lib/gcc/i686-pc-linux-gnu/4.5.3/../../../../i686-pc-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:209: syntax error

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
